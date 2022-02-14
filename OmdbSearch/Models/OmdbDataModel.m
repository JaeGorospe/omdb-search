//
//  OmdbApiService.m
//  OmdbSearch
//
//  Created by Jae Gorospe on 2022-02-11.
//

#import "OmdbDataModel.h"
#import "OmdbMovie.h"

/* Omdb Url Components */
NSString *const OmdbApiBaseUrl = @"https://www.omdbapi.com/?";
NSString *const OmdbApiKey = @"63b7e0c3";

NSString *const QueryFieldSearchTerm = @"s";
NSString *const QueryFieldApiKey = @"apiKey";
NSString *const QueryFieldMovieType = @"type";
NSString *const QueryFieldMoviePage = @"page";
NSString *const QueryValueMovieType = @"movie";

/* Http Header Components */
NSString *const HttpGet = @"GET";
NSString *const HttpHeaderFieldAccept = @"accept";
NSString *const HttpHeaderAcceptFieldValue = @"application/json";

/* Omdb Server Returned Payload Components (For use on an NSDictionary representation) */
NSString *const OmdbDictKeySearch = @"Search";
NSString *const OmdbDictKeyTitle = @"Title";
NSString *const OmdbDictKeyYear = @"Year";
NSString *const OmdbDictKeyPoster = @"Poster";

NSInteger const MaxNumberOfMoviesToDisplay = 30;
NSInteger const OmdbMoviesPerPage = 10;

@implementation OmdbDataModel

- (void)getMoviesUsingSearchTerm:(NSString*)searchTerm
{
    // API Call - Data is returned to the Landing View Controller via Delegate/Protocol.
    [self getDataFrom:[self getMultiplePageURLsWithSearchTerm:searchTerm]];
}

- (NSMutableArray<NSURL*>*)getMultiplePageURLsWithSearchTerm:(NSString*)searchTerm
{
    NSMutableArray<NSURL*> *urls = [NSMutableArray new];
    // Omdb api limits the number of movies (10) returned with each GET.
    // This feels a bit too small. Let's display 30 movies.
    // Therefore, we need to create multiple URLs for each page.
    for(int page=0; page<(MaxNumberOfMoviesToDisplay / OmdbMoviesPerPage); page++)
    {
        [urls addObject:[self buildUrlWithSearchTerm:searchTerm withPageNumber:(page + 1)]];
    }
    
    return urls;
}

- (void)getDataFrom:(NSArray<NSURL*>*)urls
{
    dispatch_group_t serviceGroup = dispatch_group_create();
    __block NSMutableArray *listOfRawMovies = [NSMutableArray new];
    NSMutableURLRequest *request = [self createUrlRequest];
    for(int i=0; i < urls.count;i++)
    {
        [request setURL:[urls objectAtIndex:(i)]];
        dispatch_group_enter(serviceGroup);
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
          ^(NSData * _Nullable data,
            NSURLResponse * _Nullable response,
            NSError * _Nullable error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            [listOfRawMovies addObjectsFromArray:dict[OmdbDictKeySearch]];
            dispatch_group_leave(serviceGroup);
        }] resume];
    }
    
    __weak OmdbDataModel *welf = self;
    dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
        // Only when all of the API calls are complete do we send this data down to our delegate.
        NSArray<OmdbMovie*> *movies = [welf convertDictionaryToMovies:listOfRawMovies];
        if(welf.delegate)
        {
            [welf.delegate didReceiveOmdbMovies:movies];
        }
    });
}

/// Map the raw movie data represented as an array of dictionaries to the local Movie object.
- (NSArray<OmdbMovie*>*)convertDictionaryToMovies:(NSArray*)payloadAsDict
{
    NSMutableArray<OmdbMovie*> *movies = [NSMutableArray new];
    for(NSDictionary * movieDict in payloadAsDict)
    {
        OmdbMovie *movie = [[OmdbMovie alloc] initWithTitle:movieDict[OmdbDictKeyTitle]
                                       yearReleased:movieDict[OmdbDictKeyYear]
                                             poster:movieDict[OmdbDictKeyPoster]];
        [movies addObject:movie];
    }
    return [movies copy];
}

- (NSURL*)buildUrlWithSearchTerm:(NSString*)searchTerm withPageNumber:(NSInteger)page
{
    NSURLComponents *components = [NSURLComponents componentsWithString:OmdbApiBaseUrl];
    // Create Each Required Query Item.
    NSURLQueryItem *apiKey = [NSURLQueryItem queryItemWithName:QueryFieldApiKey value:OmdbApiKey];
    NSURLQueryItem *searchTermParameter = [NSURLQueryItem queryItemWithName:QueryFieldSearchTerm value:searchTerm];
    NSURLQueryItem *type = [NSURLQueryItem queryItemWithName:QueryFieldMovieType value:QueryValueMovieType];
    NSURLQueryItem *pageQuery = [NSURLQueryItem queryItemWithName:QueryFieldMoviePage value:[NSString stringWithFormat: @"%ld", (long)page]];
    
    // Put it all together.
    components.queryItems = @[searchTermParameter, type, pageQuery, apiKey];
    return components.URL;
}

- (NSMutableURLRequest*)createUrlRequest
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:HttpGet];
    [request setValue:HttpHeaderAcceptFieldValue forHTTPHeaderField:HttpHeaderFieldAccept];
    return request;
}

@end

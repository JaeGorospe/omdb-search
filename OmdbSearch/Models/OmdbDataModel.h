//
//  OmdbApiService.h
//  OmdbSearch
//
//  Created by Jae Gorospe on 2022-02-11.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@class OmdbMovie;

@protocol OmdbMoviePresenterDelegate;

@interface OmdbDataModel : NSObject

@property (nonatomic, assign) id<OmdbMoviePresenterDelegate> delegate;

-(void)getMoviesUsingSearchTerm:(NSString*)searchTerm;

@end

@protocol OmdbMoviePresenterDelegate <NSObject>
- (void)didReceiveOmdbMovies:(NSArray<OmdbMovie*>*)movies;
@end

NS_ASSUME_NONNULL_END

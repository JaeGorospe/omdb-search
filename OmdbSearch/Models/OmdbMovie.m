//
//  Movie.m
//  OmdbSearch
//
//  Created by Jae Gorospe on 2022-02-11.
//

#import "OmdbMovie.h"

@implementation OmdbMovie

- (instancetype)initWithTitle:(NSString*)title
                 yearReleased:(NSString*)yearReleased
                       poster:(NSString*)poster
{
    self = [super init];
    if (self)
    {
        self.title = title;
        self.yearReleased = yearReleased;
        self.poster = poster;
    }
    return self;
}

- (nullable NSURL*)posterUrl
{
    return [NSURL URLWithString:self.poster];
}

@end

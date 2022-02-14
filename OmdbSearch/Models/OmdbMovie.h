//
//  Movie.h
//  OmdbSearch
//
//  Created by Jae Gorospe on 2022-02-11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OmdbMovie : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * yearReleased;
@property (nonatomic, strong) NSString * poster;

- (instancetype)initWithTitle:(NSString*)title
                 yearReleased:(NSString*)yearReleased
                       poster:(NSString*)poster;

- (nullable NSURL*)posterUrl;

@end

NS_ASSUME_NONNULL_END

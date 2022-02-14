//
//  LandingScreenMovieTableViewCell.h
//  OmdbSearch
//
//  Created by Jae Gorospe on 2022-02-11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OmdbMovie;

@interface OmdbMovieTableViewCell : UITableViewCell

@property (nonatomic, strong) OmdbMovie *movie;

- (void)initCellWithMovie:(OmdbMovie*)movie;

@end

NS_ASSUME_NONNULL_END

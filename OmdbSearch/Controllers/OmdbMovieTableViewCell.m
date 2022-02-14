//
//  LandingScreenMovieTableViewCell.m
//  OmdbSearch
//
//  Created by Jae Gorospe on 2022-02-11.
//

#import "OmdbMovieTableViewCell.h"
#import "OmdbMovie.h"

@interface OmdbMovieTableViewCell()

/* Storyboard Elements */
@property (weak, nonatomic) IBOutlet UILabel *title; // Ex: "The Social Network"
@property (weak, nonatomic) IBOutlet UILabel *yearReleased; // Ex: "2010"
@property (weak, nonatomic) IBOutlet UIImageView *poster;

@end

@implementation OmdbMovieTableViewCell

- (void)initCellWithMovie:(OmdbMovie*)movie
{
    self.movie = movie;

    // Label Text Setup
    self.title.text = movie.title;
    self.yearReleased.text = movie.yearReleased;
    
    // Retrieve the image from the poster URL and display it on the cell.
    [self displayPoster];
}

- (void)displayPoster
{
    // We need to do the retrieving-of-data asynchronously.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
     ^{
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.movie.posterUrl];
        //Completion Handler -- Let's update the image on the main thread.
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.poster.image = [UIImage imageWithData:imageData];
         });
     });
}

@end

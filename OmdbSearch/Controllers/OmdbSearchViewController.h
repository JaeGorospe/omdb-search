//
//  ViewController.h
//  OmdbSearch
//
//  Created by Jae Gorospe on 2022-02-10.
//

#import <UIKit/UIKit.h>

#import "OmdbDataModel.h"

@interface OmdbSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, OmdbMoviePresenterDelegate>


@end


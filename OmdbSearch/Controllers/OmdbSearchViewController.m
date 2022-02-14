//
//  ViewController.m
//  OmdbSearch
//
//  Created by Jae Gorospe on 2022-02-10.
//

#import "OmdbDataModel.h"
#import "OmdbMovie.h"
#import "OmdbMovieTableViewCell.h"
#import "OmdbSearchViewController.h"

@interface OmdbSearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *landingScreenTableview;

@property (nonatomic, strong) NSMutableArray<OmdbMovie*> *movies;
@property (nonatomic, strong) OmdbDataModel *dataModel;

@end

@implementation OmdbSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.movies = [NSMutableArray new];
    self.dataModel = [OmdbDataModel new];
    
    self.dataModel.delegate = self;
}

- (void)displayBadSearchAlert
{
    // The hardcoded strings for the messages should probably live in a localizable strings file.
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Unable To Find Movie"
                                                               message:@"The keywords you entered are not specific enough. Please try again."
                                                        preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OmdbMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LandingScreenMovieTableViewCell" forIndexPath:indexPath];
    [cell initCellWithMovie:[self.movies objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // New search term. Let's start over!
    [self.movies removeAllObjects];
    
    // Update the UI in the main thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.landingScreenTableview reloadData];
    });
    
    // Commence an asynchronous api call to retrieve movies using the search term.
    [self.dataModel getMoviesUsingSearchTerm:searchBar.text];
}

#pragma mark - OmdbMoviePresenterDelegate Methods

- (void)didReceiveOmdbMovies:(NSArray<OmdbMovie *> *)movies
{
    if(movies.count == 0)
    {
        [self displayBadSearchAlert];
    }
    else
    {
        // Update local data with those recently retrieved from the server.
        [self.movies addObjectsFromArray:movies];
        
        // Update the UI in the main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.landingScreenTableview reloadData];
        });
    }
}

@end

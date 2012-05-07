//
//  TopPlacesTableViewController.m
//  FlickrApp
//
//  Created by Drew Rosenberg on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotosFromLocationTableViewController.h"

@interface TopPlacesTableViewController ()
@property (nonatomic, strong) NSArray * topPlaces;
@end

@implementation TopPlacesTableViewController

@synthesize topPlaces = _topPlaces;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-( NSArray *)sortFlickrRecordsByField:(id)field{

    NSMutableArray * sortedTopPlaces = [self.topPlaces mutableCopy];
        
    [sortedTopPlaces sortUsingDescriptors:
        [NSArray arrayWithObject:[[NSSortDescriptor alloc]
                                initWithKey:field
                                  ascending:YES]]];
    
    return sortedTopPlaces;
}

-(void) awakeFromNib{
    self.title = @"Top Places";
}
- (IBAction)refresh:(id)sender {
    [self.tableView reloadData];
    
    UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActionSheetStyleBlackTranslucent];
    [spinner startAnimating];
    
    UIBarButtonItem * refreshButton = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue =dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        self.topPlaces = [FlickrFetcher topPlaces];
        NSLog(@"topPlaces = %@", self.topPlaces);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //sort alphabetically by place
            self.topPlaces = [self sortFlickrRecordsByField:FLICKR_PLACE_NAME];
            self.navigationItem.rightBarButtonItem = refreshButton;
            [self.tableView reloadData];
        });
    });
    
    dispatch_release(downloadQueue);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarItem.title = @"Top Places";
    [self refresh:self];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
    [segue.destinationViewController setLocation:[self.topPlaces objectAtIndex:indexPath.row ]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Places Cell Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary * photoDetails = [self.topPlaces objectAtIndex:indexPath.row];
    NSString * location = [photoDetails objectForKey:FLICKR_PLACE_NAME];
    
    cell.textLabel.text = [location substringToIndex:[location rangeOfString:@","].location];
    cell.detailTextLabel.text = [location substringFromIndex:[location rangeOfString:@","].location+1];
    
     return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"Get Recent Photos for Location" sender:[self.tableView cellForRowAtIndexPath:indexPath]];

}

@end

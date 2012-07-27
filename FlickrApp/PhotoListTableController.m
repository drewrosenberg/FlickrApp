//
//  PhotoListTableController.m
//  FlickrApp
//
//  Created by Drew Rosenberg on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoListTableController.h"
#import "FlickrImageViewController.h"

#define USER_DEFAULTS_MAX_PHOTOS 20

@interface PhotoListTableController ()
@end

@implementation PhotoListTableController
@synthesize refreshButton = _refreshButton;
@synthesize photoList = _photoList;


///addToUserDefaults, location stuff in viewDidLoad, and query in refresh are the only 3 things that keep this from being generic
///can we call these out in separate functions and then push them to an inheriting class?



-(void)setPhotoList:(NSArray *)photoList{
    if (_photoList != photoList) {
        _photoList = photoList;
        if (self.tableView.window) [self.tableView reloadData];
    }
}

- (void) updatePhotosAndTitle{
    self.title = @"Placeholder";
    self.photoList = nil;
}

- (IBAction)refresh:(id)sender {
    //reset the table if the reset button was pressed 
    if ([sender isKindOfClass:[UIBarButtonItem class]]){
        self.photoList = nil;
        [self.tableView reloadData];
    }
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    
    dispatch_async(downloadQueue, ^{  
        dispatch_async(dispatch_get_main_queue(), ^{
            UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActionSheetStyleBlackTranslucent];
            [spinner startAnimating];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
        });
        
        
        [self updatePhotosAndTitle];
        dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"photos list =%@", self.photoList);
            self.navigationItem.rightBarButtonItem = self.refreshButton;
            [self.tableView reloadData];
        });
    });
    dispatch_release(downloadQueue);
}


#pragma mark - viewController methods

-(void) awakeFromNib{
    [super awakeFromNib];
    
    [self refresh:self];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self refresh:self];
}

- (void)viewDidUnload
{
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.photoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary * photoDetails = [self.photoList objectAtIndex:indexPath.row];
    NSString * title = [photoDetails objectForKey:FLICKR_PHOTO_TITLE];
    NSString * description = [photoDetails objectForKey:FLICKR_PHOTO_DESCRIPTION];
    
    if (title) {
        cell.textLabel.text = title;
        cell.detailTextLabel.text = description;
    }else if (description){
        cell.textLabel.text = description;
        cell.detailTextLabel.text = @"no title";
    }
    else{
        cell.textLabel.text = @"UNKNOWN";
        cell.detailTextLabel.text = @"no description";
    }
    
    return cell;
}


-(void) addToUserDefaults:( NSDictionary*)photoSelection{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray * mutableRecentPhotos = [[userDefaults objectForKey:RECENT_SELECTIONS_KEY] mutableCopy];
    
    if (!mutableRecentPhotos) mutableRecentPhotos = [NSMutableArray array];
    
    if (![mutableRecentPhotos containsObject:photoSelection]){
        [mutableRecentPhotos addObject:photoSelection];
        
        if (mutableRecentPhotos.count > USER_DEFAULTS_MAX_PHOTOS){
            [mutableRecentPhotos removeObjectAtIndex:0]; // remove the oldest
        }
        
        
        [userDefaults setObject:mutableRecentPhotos forKey:RECENT_SELECTIONS_KEY];
        //NSLog(@"past selections: %@\n",[[NSUserDefaults standardUserDefaults] objectForKey:RECENT_SELECTIONS_KEY]);
        [userDefaults synchronize];
    }
}

-(void) removeFromUserDefaults: (NSDictionary*)photoSelection{
    //make mutable copy of recent photos list in user defaults
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray * mutableRecentPhotos = [[userDefaults objectForKey:RECENT_SELECTIONS_KEY] mutableCopy];
    
    //remove the photo from the mutable copy
    [mutableRecentPhotos removeObject:photoSelection];

    //write the new photo list back to user defaults
    [userDefaults setObject:mutableRecentPhotos forKey:RECENT_SELECTIONS_KEY];

    //synchronize user defaults
    [userDefaults synchronize];
}


#pragma mark - Table view delegate


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"image"]){
        NSDictionary * photo = [self.photoList objectAtIndex:indexPath.row];
        [segue.destinationViewController setTitle:[[self.photoList objectAtIndex:indexPath.row] objectForKey:FLICKR_PHOTO_TITLE]];
        [segue.destinationViewController setImageRecord:photo];
    }
}

-(FlickrImageViewController *)splitViewFlickerController{
    id fivc = [self.splitViewController.viewControllers lastObject];
    if (![fivc isKindOfClass:[FlickrImageViewController class]]) {
        fivc = nil;
    }
    return fivc;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self addToUserDefaults:[self.photoList objectAtIndex:indexPath.row]];
    if (!self.splitViewController){
        [self performSegueWithIdentifier:@"image" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    }else{
        NSDictionary * photo = [self.photoList objectAtIndex:indexPath.row];
        [[self.splitViewController.viewControllers lastObject] setTitle:[[self.photoList objectAtIndex:indexPath.row] objectForKey:FLICKR_PHOTO_TITLE]];

        if ([self splitViewFlickerController]) {                      // if in split view
            [[self splitViewFlickerController] setImageRecord:photo];  // just set the image in detail
        }
    }
}

@end

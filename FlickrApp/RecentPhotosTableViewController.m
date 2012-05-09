//
//  RecentPhotosTableViewController.m
//  FlickrApp
//
//  Created by Drew Rosenberg on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentPhotosTableViewController.h"

@interface RecentPhotosTableViewController ()

@end

@implementation RecentPhotosTableViewController

- (void) updatePhotosAndTitle{
    //    [super updatePhotosAndTitle]; - no need to do this - these are set to nil in super
    
    
    self.title = @"Recent Photos";
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    self.photoList = [defaults objectForKey:RECENT_SELECTIONS_KEY];
    
    [self.tableView reloadData];
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"Recent Photos";
}

-(void) awakeFromNib{
    [super awakeFromNib];
    [self updatePhotosAndTitle];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updatePhotosAndTitle];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.photoList.count;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //begin updates
        [tableView beginUpdates];

        //remove the photo from user defaults
        [self removeFromUserDefaults:[self.photoList objectAtIndex:indexPath.row]];

        //make mutable copy of the photo list
        NSMutableArray * mutablePhotoList = [self.photoList mutableCopy];
        
        //remove the photo from the mutable copy
        [mutablePhotoList removeObject:[mutablePhotoList objectAtIndex:indexPath.row]];
        
        //write the mutable copy back to the photo list
        self.photoList = mutablePhotoList;
        
        //update tableView
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

        //end updates
        [tableView endUpdates];
    }   
    
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

@end





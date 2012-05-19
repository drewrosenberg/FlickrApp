//
//  PhotoListTableController.h
//  FlickrApp
//
//  Created by Drew Rosenberg on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrFetcher.h"

#define RECENT_SELECTIONS_KEY @"PhotoListController.recent selections"


@interface PhotoListTableController : UITableViewController
    <UITableViewDataSource, UITableViewDelegate, UISplitViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *mapButton;


@property (nonatomic, strong) NSArray * photoList;

-(void) updatePhotosAndTitle;
-(IBAction)refresh:(id)sender;
-(void) removeFromUserDefaults: (NSDictionary*)photoSelection;


@end

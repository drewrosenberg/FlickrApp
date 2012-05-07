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
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"Recent Photos";
}

@end



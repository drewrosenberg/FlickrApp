//
//  PhotosFromLocationTableViewController.m
//  FlickrApp
//
//  Created by Drew Rosenberg on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotosFromLocationTableViewController.h"

@implementation PhotosFromLocationTableViewController
@synthesize refreshButton = _refreshButton;
@synthesize location = _location;

- (void) updatePhotosAndTitle{
//    [super updatePhotosAndTitle]; - no need to do this - these are set to nil in super
    
    
    NSString * location = [self.location objectForKey:FLICKR_PLACE_NAME];
    self.title = [location substringToIndex:[location rangeOfString:@","].location];

    self.photoList = [FlickrFetcher photosInPlace:self.location maxResults:50];
}


- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}
@end

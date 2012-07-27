//
//  FlickrPhotoAnnotation.m
//  FlickrApp
//
//  Created by Drew Rosenberg on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrPhotoAnnotation.h"
#import "FlickrFetcher.h"


@implementation FlickrPhotoAnnotation
@synthesize photo = _photo;

+(FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo{
    FlickrPhotoAnnotation *annotation = [[FlickrPhotoAnnotation alloc] init];
    annotation.photo = photo;
    return annotation;
}

-(NSString *)title{
    NSString * title = [self.photo objectForKey:FLICKR_PHOTO_TITLE];
    if (title.length > 0){
        return title;
    }
    else {
        return @"no title";
    }
}

-(NSString *)subtitle{
    return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

-(CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.photo objectForKey:FLICKR_LONGITUDE] doubleValue];
    
    return coordinate;
}

@end

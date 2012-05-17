//
//  FlickrLocationAnnotation.m
//  FlickrApp
//
//  Created by Drew Rosenberg on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrLocationAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrLocationAnnotation
@synthesize location = _location;

+(FlickrLocationAnnotation *)annotationForLocation:(NSDictionary *)location{
    FlickrLocationAnnotation *annotation = [[FlickrLocationAnnotation alloc] init];
    annotation.location = location;
    return annotation;
}

-(NSString *)title{
    NSString * location = [self.location objectForKey:FLICKR_PLACE_NAME];
    
    return [location substringToIndex:[location rangeOfString:@","].location];
}

-(NSString *)subtitle{
    NSString * location = [self.location objectForKey:FLICKR_PLACE_NAME];

    return [location substringFromIndex:[location rangeOfString:@","].location+1];

}

-(CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.location objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.location objectForKey:FLICKR_LONGITUDE] doubleValue];
    
    return coordinate;
}
@end

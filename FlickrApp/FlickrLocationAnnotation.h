//
//  FlickrLocationAnnotation.h
//  FlickrApp
//
//  Created by Drew Rosenberg on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <MapKit/mapkit.h>

@interface FlickrLocationAnnotation : NSObject <MKAnnotation>
+(FlickrLocationAnnotation *)annotationForLocation:(NSDictionary *)location; //Flickr Photo Dictionary
@property (nonatomic, strong) NSDictionary *location;
@end

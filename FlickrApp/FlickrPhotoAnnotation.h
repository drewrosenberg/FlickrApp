//
//  FlickrPhotoAnnotation.h
//  FlickrApp
//
//  Created by Drew Rosenberg on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/mapkit.h>

@interface FlickrPhotoAnnotation : NSObject <MKAnnotation>
+(FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo; //Flickr Photo Dictionary

@property (nonatomic, strong) NSDictionary *photo;
@end

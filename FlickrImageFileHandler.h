//
//  FlickrImageFileHandler.h
//  FlickrApp
//
//  Created by Drew Rosenberg on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrImageFileHandler : NSObject
+(NSData *) getImageData:(NSDictionary *)imageRecord;
@end

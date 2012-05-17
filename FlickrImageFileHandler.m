//
//  FlickrImageFileHandler.m
//  FlickrApp
//
//  Created by Drew Rosenberg on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrImageFileHandler.h"
#import "FlickrFetcher.h"

@implementation FlickrImageFileHandler

+(void) freeSpace:(double)maxSpace atLocation:(NSURL *)url{
    NSFileManager * cacheFileManager = [NSFileManager defaultManager];
    
    NSArray * fileList = [cacheFileManager contentsOfDirectoryAtPath:[url path] error:nil];
    
    int directorySize = 0;
    NSString * oldestFileName = nil;
    NSDate * oldestFileDate = [NSDate distantFuture];
    
    //get the oldest file and add up total disk usage of directory
    for (NSString * file in fileList){
        if (file){
            NSDictionary * fileAttributes = [cacheFileManager attributesOfItemAtPath:[[url URLByAppendingPathComponent:file] path] error:nil];
            NSLog(@"%@ was created on %@", file, [fileAttributes objectForKey:NSFileCreationDate]);
            int fileSize = [[fileAttributes objectForKey:NSFileSize] intValue];
            directorySize += fileSize;
                
            if (([[fileAttributes objectForKey:NSFileCreationDate] timeIntervalSinceDate:oldestFileDate])<0){
                oldestFileName = file;
                oldestFileDate = [fileAttributes objectForKey:NSFileCreationDate];
            }
        }
    }

    //if directory size is over the limit, remove oldest file
    //NSLog(@"directory size is %i", directorySize);
    NSLog(@"%@ is the oldest file", oldestFileName);
    if (directorySize > maxSpace) {
        NSLog(@"removing oldest file %@", oldestFileName);

        //remove the file unless it doesn't exist
        if (oldestFileName) [cacheFileManager removeItemAtURL:[url URLByAppendingPathComponent:oldestFileName] error:nil];
//        NSLog(@"%@ removed from files %@", oldestFileName, fileList);
        [self freeSpace:maxSpace atLocation:url];
    }
    
//    NSLog(@"size of %@ is %@", [url path],[[cacheFileManager attributesOfItemAtPath:[url path] error:nil] objectForKey:NSFileSize]);
//    NSLog(@"age of %@ is %@", [url path],[[cacheFileManager attributesOfItemAtPath:[url path] error:nil] objectForKey:NSFileCreationDate]);
}

+(NSData *) getImageData:(NSDictionary *)imageRecord{
    //Get the internet URL
    NSURL * imageURL = [FlickrFetcher urlForPhoto:imageRecord format:FlickrPhotoFormatLarge];

    NSFileManager * cacheFileManager = [[NSFileManager alloc] init];
    
    //set the path of the local cache directory
    NSURL * cachDirectoryURL = [[cacheFileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL * localImageURL = [[NSURL alloc] init ];
    //set the URL of the local file
    if (imageRecord){
        localImageURL = [cachDirectoryURL URLByAppendingPathComponent:[[imageRecord objectForKey:FLICKR_PHOTO_ID] stringByAppendingString:@".jpg"]];
    }else{
        localImageURL = nil;
    }
    
    //get the image
    NSData * imageData = [[NSData alloc] init ];
    
    //if the file does not exist locally, download it and then cache it
    if (![cacheFileManager fileExistsAtPath:[localImageURL path]]){
        //get the Image
        imageData = [NSData dataWithContentsOfURL:imageURL];
        
        //cache the image
        [imageData writeToURL:localImageURL atomically:YES];

        //if the cache size is > 10MB, delete the oldest photo
        [self freeSpace:10000000 atLocation:cachDirectoryURL];
        
    }else {
        imageData = [NSData dataWithContentsOfURL:localImageURL];
    }
    return imageData;
}

@end

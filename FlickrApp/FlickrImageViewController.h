//
//  FlickrImageViewController.h
//  FlickrApp
//
//  Created by Drew Rosenberg on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrImageFileHandler.h"

@protocol splitViewBarButtonItemPresenter <NSObject>
@property (nonatomic, weak) UIBarButtonItem * splitViewBarButtonItem;
@end


@interface FlickrImageViewController : UIViewController 
@property (nonatomic, weak) id imageRecord;
@end

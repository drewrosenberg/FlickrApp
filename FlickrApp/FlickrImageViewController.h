//
//  FlickrImageViewController.h
//  FlickrApp
//
//  Created by Drew Rosenberg on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol splitViewBarButtonItemPresenter <NSObject>
@property (nonatomic, weak) UIBarButtonItem * splitViewBarButtonItem;
@end


@interface FlickrImageViewController : UIViewController <UIScrollViewDelegate, UISplitViewControllerDelegate, splitViewBarButtonItemPresenter>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) id imageRecord;


@end

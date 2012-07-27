//
//  FlickrImageViewController.m
//  FlickrApp
//
//  Created by Drew Rosenberg on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrImageViewController.h"
#import "FlickrFetcher.h"

@interface FlickrImageViewController () 
                    <UIScrollViewDelegate, 
                    UISplitViewControllerDelegate, 
                    splitViewBarButtonItemPresenter>


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic) BOOL spinnerStatus; //yes is spinning, no is not spinning
@property (weak, nonatomic) IBOutlet UILabel *toolBarTitle;

@end

@implementation FlickrImageViewController
@synthesize toolBarTitle = _toolBarTitle;

@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize toolbar = _toolbar;
@synthesize spinner = _spinner;
@synthesize imageRecord = _imageRecord;
@synthesize spinnerStatus = _spinnerStatus;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

#pragma mark - custom setters
-(void)setImageRecord:(id)imageRecord{
    if (imageRecord != _imageRecord) {
        _imageRecord = imageRecord;
        [self refreshView:self];
    }
}

-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    self.toolBarTitle.text = title;
}

-(void)setSpinnerStatus:(BOOL)spinnerStatus{
    if (spinnerStatus){
        [self.spinner startAnimating]; 
    }else {
        [self.spinner stopAnimating];
    }
    _spinnerStatus = spinnerStatus;
}


# pragma mark - FlickrImageViewController methods

-(void)drawImage{


    //reset zoom to 1
    self.scrollView.zoomScale = 1;

    //set imageView frame
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    
    //set contentsize
    self.scrollView.contentSize = self.imageView.image.size;

    //get size of image and view
    CGSize imageSize = self.imageView.image.size;
    CGSize viewSize = self.scrollView.bounds.size;
    
    //set default zoom scale
    self.scrollView.zoomScale = MAX(viewSize.height/imageSize.height, viewSize.width/imageSize.width);   
    
    //set minimum zoom scale
    self.scrollView.minimumZoomScale =
    MIN(viewSize.height/imageSize.height, 
        viewSize.width/imageSize.width);
    
    //log info
    NSLog(@"======");
    NSLog(@"imageWidth      = %f", imageSize.width);
    NSLog(@"imageViewWidth  = %f", viewSize.width);
    NSLog(@"imageHeight     = %f", imageSize.height);
    NSLog(@"imageViewHeight = %f", viewSize.height);
    NSLog(@"MinZoom         = %f", self.scrollView.minimumZoomScale);
    NSLog(@"zoomscale       = %f", self.scrollView.zoomScale);
    NSLog(@"MaxZoom         = %f", self.scrollView.maximumZoomScale);
    NSLog(@"======");

}
- (IBAction)refreshView:(id)sender {
    //turn spinner on and clear image
    self.spinnerStatus = YES;
    self.imageView.image = nil;
    
    dispatch_queue_t imageDownloadQueue = dispatch_queue_create("image downloader", NULL);
    dispatch_async(imageDownloadQueue, ^{  
        NSURL * imageURL = [FlickrFetcher urlForPhoto:self.imageRecord format:FlickrPhotoFormatLarge];
        NSLog(@"imageURL at segue = %@", imageURL);
        NSData * imageData = [[NSData alloc] init];
        NSLog(@"imageURL in imageDownloadQueue = %@",imageURL );
        if (imageURL){
            imageData = [NSData dataWithContentsOfURL:imageURL];
        }else{
            self.title = @"NO IMAGE AVAILABLE";
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"imageURL in MainQueue = %@",imageURL );
            
            //turn spinner off
            self.spinnerStatus = NO;

            //save image
            self.imageView.image = [UIImage imageWithData:imageData];

            //draw the image
            [self drawImage];
        });
    });
    dispatch_release(imageDownloadQueue);
}

#pragma mark - viewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//set as the scrollview delegate
    self.scrollView.delegate = self;
    
    //set as the splitViewController's delegate
    self.splitViewController.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated{
   // [super viewWillAppear:YES];
    [self refreshView:self];
}

-(void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    //zoom the image to fill up the view
    if (self.imageView.image) [self drawImage];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setToolbar:nil];
    [self setSpinner:nil];
    [self setToolBarTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - splitViewControllerDelegate

-(id <splitViewBarButtonItemPresenter> )splitViewBarButtonItemPresenter{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if ([detailVC conformsToProtocol:@protocol(splitViewBarButtonItemPresenter)]){
        return detailVC;
    }else return nil;
}

-(BOOL) splitViewController:(UISplitViewController *)svc 
   shouldHideViewController:(UIViewController *)vc 
              inOrientation:(UIInterfaceOrientation)orientation
{
    NSLog(@"%s", __FUNCTION__);
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

-(void) splitViewController:(UISplitViewController *)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)pc{
    
    NSLog(@"%s", __FUNCTION__);
    barButtonItem.title = self.title;
    [pc setPopoverContentSize:CGSizeMake(480.0f, 320.0f) animated:NO];
    //tell the detail view to put this button up
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
    
}

-(void) splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSLog(@"%s", __FUNCTION__);
    //tell the detail view to take the button away
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}


#pragma mark - scrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


@end

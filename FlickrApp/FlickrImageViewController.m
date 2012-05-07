//
//  FlickrImageViewController.m
//  FlickrApp
//
//  Created by Drew Rosenberg on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrImageViewController.h"
#import "PhotoListTableController.h"
#import "FlickrFetcher.h"

@interface FlickrImageViewController ()
@property (nonatomic, strong) UIImage * image;
@end

@implementation FlickrImageViewController
@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize imageRecord = _imageRecord;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize image = _image;

-(void)setImageRecord:(id)imageRecord{
    if (imageRecord != _imageRecord) {
        _imageRecord = imageRecord;
        [self refreshView];
    }
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
- (IBAction)plus:(id)sender {
    self.scrollView.zoomScale = self.scrollView.zoomScale*10;
}
- (IBAction)minus:(id)sender {
    self.scrollView.zoomScale = self.scrollView.zoomScale*10;
}

-(void)drawImage{
    self.scrollView.delegate = self;
    [self.scrollView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView sizeToFit];
    self.imageView.image = self.image;
    self.imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    
    self.scrollView.contentSize = self.image.size;
    
    CGSize imageSize = self.image.size;
    CGSize viewSize = self.view.bounds.size;

    self.scrollView.minimumZoomScale = viewSize.width/(4*imageSize.width);
//        MIN(viewSize.height/imageSize.height, 
  //          viewSize.width/imageSize.width);
    
    self.scrollView.maximumZoomScale = 6.0;
    
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    //MAX( viewSize.height/imageSize.height, viewSize.width/imageSize.width);
    NSLog(@"zoomscale = %f", self.scrollView.zoomScale);


    NSLog(@"======");
    NSLog(@"imageWidth      = %f", imageSize.width);
    NSLog(@"imageViewWidth  = %f", viewSize.width);
    NSLog(@"imageHeight     = %f", imageSize.height);
    NSLog(@"imageViewHeight = %f", viewSize.height);
    NSLog(@"MinZoom         = %f", self.scrollView.minimumZoomScale);
    NSLog(@"zoomscale       = %f", self.scrollView.zoomScale);
    NSLog(@"MaxZoom         = %f", self.scrollView.maximumZoomScale);
    NSLog(@"======");
    [self.view setNeedsDisplay];
}

-(void)refreshView{
    
    UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActionSheetStyleBlackTranslucent];
    [spinner startAnimating];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
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
            self.navigationItem.rightBarButtonItem = nil;

            self.image = [UIImage imageWithData:imageData];

            if (self.image) [self drawImage];
        });
    });
    dispatch_release(imageDownloadQueue);
}

-(void) awakeFromNib{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self refreshView];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self refreshView];
}

-(void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (self.image) [self drawImage];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end

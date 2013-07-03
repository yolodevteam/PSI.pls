//
//  MainViewController.m
//  PSI
//
//  Created by Terence Tan on 1/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "MainViewController.h"
#import "DAPagesContainer.h"
#import "UIImage+Tools.m"
#import "InformationViewController.h"
#import "PSIData.h"

@interface MainViewController ()


@property (strong, nonatomic) DAPagesContainer *pagesContainer;

@end

@implementation MainViewController



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
    NSLog(@"hello swag");
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = self.pagesView.bounds;
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.pagesView addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    
    UIViewController *beaverViewController = [[UIViewController alloc] init];
    UIImageView *beaverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beaver.jpg"]];
    beaverImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [beaverViewController.view addSubview:beaverImageView];
    beaverViewController.title = @"History";

    UIViewController *buckDeerViewController = [[UIViewController alloc] init];
    UIImageView *buckDeerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buckDeer.jpg"]];
    buckDeerImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [buckDeerViewController.view addSubview:buckDeerImageView];
    buckDeerViewController.title = @"3-Hour";
    
    UIViewController *catViewController = [[UIViewController alloc] init];
    UIImageView *catImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat.jpg"]];
    catImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [catViewController.view addSubview:catImageView];
    catViewController.title = @"North";
    
    UIViewController *lionViewController = [[UIViewController alloc] init];
    UIImageView *lionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lion.jpg"]];
    lionImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [lionViewController.view addSubview:lionImageView];
    lionViewController.title = @"South";
    
    self.pagesContainer.viewControllers = @[beaverViewController, buckDeerViewController, catViewController, lionViewController];
    // Do any additional setup after loading the view from its nib.
    
    NSString *date = [self getSingaporeTimeWithMinutes:NO];
    
    int hour = [date intValue];
    
    if (hour > 19 || hour < 7) {
        // Set a night time background picture (this is only if we can't get webcam images before release)
        if (IS_4INCH_SCREEN) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[[[UIImage imageNamed:@"bg_iphone-568h.jpg"] imageWithGaussianBlur] CGImage] scale:2.0 orientation:UIImageOrientationUp]];
            [self.view addSubview:imageView];
            [self.view sendSubviewToBack:imageView];
        } else {
            self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"bg_iphone.jpg"] imageWithGaussianBlur]];
        }
    } else {
        if (IS_4INCH_SCREEN) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[[[UIImage imageNamed:@"bg_blue-568h.jpg"] imageWithGaussianBlur] CGImage] scale:2.0 orientation:UIImageOrientationUp]];
            [self.view addSubview:imageView];
            [self.view sendSubviewToBack:imageView];
        } else {
            self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"bg_blue.jpg"] imageWithGaussianBlur]];
        }
    }
    
    [self.info addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    
   /* _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height + 20)];
    _loadingView.backgroundColor = [UIColor blackColor];
    
    _act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _act.center = _loadingView.center;
    
    [_loadingView addSubview:_act];
    [_act startAnimating];
    
    _errorLabel = [[UILabel alloc] init];
    _errorLabel.alpha = 0.0;
    _errorLabel.frame = CGRectMake(0, 0, 320, 100);
    _errorLabel.center = _loadingView.center;
    _errorLabel.textColor = [UIColor whiteColor];
    _errorLabel.font = [UIFont fontWithName:@"Helvetica UltraLight" size:30];
    _errorLabel.backgroundColor = [UIColor clearColor];
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.textColor = [UIColor whiteColor];
    
    [_loadingView addSubview:_errorLabel];
    
    _errorRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    _errorRefresh.frame = CGRectMake(0, 0, 15, 19);
    [_errorRefresh setImage:[UIImage imageNamed:@"UIBarButtonRefresh.png"] forState:UIControlStateNormal];
    [_errorRefresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
    
    [_loadingView addSubview:_errorRefresh];
    
    [self.view addSubview:_loadingView];
    */
    PSIData* data = [[PSIData alloc] init];
    [data loadData];
    

}
- (NSString *)getSingaporeTimeWithMinutes:(BOOL)minutes
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (minutes) {
        dateFormatter.dateFormat = @"HH:mm";
    } else {
        dateFormatter.dateFormat = @"HH";
    }
    
    NSTimeZone *sgt = [NSTimeZone timeZoneWithAbbreviation:@"SGT"];
    //[dateFormatter setTimeZone:sgt];
    
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    
    return time;
}
- (void)showInfo
{
    InformationViewController *info = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
    info.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentModalViewController:info animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

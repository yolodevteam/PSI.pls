//
//  MainViewController.m
//  PSI
//
//  Created by Terence Tan on 1/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "UIImage+Tools.m"
#import "DataViewController.h"
#import "RegionViewController.h"
#import "HistoryViewController.h"

@interface MainViewController ()


@end

@implementation MainViewController {
    InformationViewController *info;
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
    NSLog(@"hello swag");

    NSString *date = [self getSingaporeTimeWithMinutes:NO];

    int hour = [date intValue];

    /* if (hour > 18 || hour < 6) {
        // Set a night time background picture (this is only if we can't get webcam images before release)
        if (IS_4INCH_SCREEN) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[[[UIImage imageNamed:@"bg_iphone-568h.jpg"] imageWithGaussianBlur] CGImage] scale:2.0 orientation:UIImageOrientationUp]];
            [self.view addSubview:imageView];
            [self.view sendSubviewToBack:imageView];
        } else {
            self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"bg_iphone.jpg"] imageWithGaussianBlur]];
        }
    } else {*/
        if (IS_4INCH_SCREEN) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[[[UIImage imageNamed:@"bg_blue-568h.jpg"] imageWithGaussianBlur] CGImage] scale:2.0 orientation:UIImageOrientationUp]];
            [self.view addSubview:imageView];
            [self.view sendSubviewToBack:imageView];
        } else {
            self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"bg_blue.jpg"] imageWithGaussianBlur]];
        }
    //}


    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = self.pagesView.bounds;
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.pagesView addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];

    HistoryViewController *historyController = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
    historyController.title = @"History";

    RegionViewController *threeHourController = [[RegionViewController alloc] initWithNibName:@"RegionViewController" bundle:nil];
    threeHourController.title = @"3-Hour";
    threeHourController.region = @"3hr";


    RegionViewController *northController = [[RegionViewController alloc] initWithNibName:@"RegionViewController" bundle:nil];
    northController.title = @"North";
    northController.region = @"north";

    RegionViewController *southController = [[RegionViewController alloc] initWithNibName:@"RegionViewController" bundle:nil];
    southController.title = @"South";
    southController.region = @"south";

    RegionViewController *eastController = [[RegionViewController alloc] initWithNibName:@"RegionViewController" bundle:nil];
    eastController.title = @"East";
    eastController.region = @"east";

    RegionViewController *westController = [[RegionViewController alloc] initWithNibName:@"RegionViewController" bundle:nil];
    westController.title = @"West";
    westController.region = @"west";

    RegionViewController *centralController = [[RegionViewController alloc] initWithNibName:@"RegionViewController" bundle:nil];
    centralController.title = @"Central";
    centralController.region = @"central";


   // [historyController.tableView removeObserver:<#(NSObject *)observer#> forKeyPath:<#(NSString *)keyPath#> :self forKeyPath:@"contentOffset" options:0 context:nil];

    self.pagesContainer.viewControllers = @[historyController, threeHourController, northController, southController, eastController, westController, centralController];
    [self.pagesContainer setSelectedIndex:1 animated:NO];
    // Do any additional setup after loading the view from its nib.
    
        
    [self.info addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];

    UIColor *color = _refresh.currentTitleColor;
    _refresh.titleLabel.layer.shadowColor = [color CGColor];
    _refresh.titleLabel.layer.shadowRadius = 4.0f;
    _refresh.titleLabel.layer.shadowOpacity = 0.9;
    _refresh.titleLabel.layer.shadowOffset = CGSizeZero;
    _refresh.titleLabel.layer.masksToBounds = YES;
    _refresh.showsTouchWhenHighlighted = YES;

    [_refresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];

    [self showLoadingView];

    self.data =  [[PSIData alloc] init];
    self.data.delegate = self;
    [self.data loadData];

}

- (void)showInfo
{
    if (info == nil) {
        info = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
        info.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        info.delegate = self;
    }
    //[self presentModalViewController:info animated:YES ];
    [self presentTransparentModalViewController:info animated:YES withAlpha:0.89];
}
- (void)closeView {
    [self dismissTransparentModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadingCompleted:(PSIData *)data {
    _refresh.enabled = YES;
    int lasthour = [self.data getLastHour];
    NSString* suffix;
    if (lasthour > 12) {
        suffix = @"pm";
        lasthour = lasthour - 12;
    }
    else if (lasthour == 0) {
        suffix = @"am";
        lasthour = 12;
    }
    else if (lasthour == 12) {
        suffix = @"pm";
        //lasthour = 12;
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ at %d%@", [self getSingaporeDate], lasthour, suffix];
    

    for (RegionViewController *region in self.pagesContainer.viewControllers) {
        NSLog(@"title %@", region.title);
        [region setData:data];
    }
    [self removeLoadingView];
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
    [dateFormatter setTimeZone:sgt];

    NSString *time = [dateFormatter stringFromDate:[NSDate date]];

    return time;
}

- (NSString *)getSingaporeDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"EEE, dd MMM";

    
    NSTimeZone *sgt = [NSTimeZone timeZoneWithAbbreviation:@"SGT"];
    [dateFormatter setTimeZone:sgt];
    
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    
    return time;
}



#pragma mark - Transparent Modal View
-(void) presentTransparentModalViewController: (UIViewController *) aViewController
                                     animated: (BOOL) isAnimated
                                    withAlpha: (CGFloat) anAlpha{

    self.transparentModalViewController = aViewController;
    UIView *view = aViewController.view;

    view.opaque = NO;
    view.alpha = anAlpha;
    [view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *each = obj;
        each.opaque = NO;
        each.alpha = anAlpha;
    }];

    if (isAnimated) {
        //Animated
        CGRect mainrect = [[UIScreen mainScreen] bounds];

        [self.view addSubview:view];
        view.alpha = 0;
        view.frame = mainrect;
        [UIView animateWithDuration:0.3
                animations:^{
                    view.alpha = anAlpha;

                } completion:^(BOOL finished) {
            //nop
        }];

    } else{
        view.frame = [[UIScreen mainScreen] bounds];
        [self.view addSubview:view];
    }






}

-(void) dismissTransparentModalViewControllerAnimated:(BOOL) animated{

    if (animated) {
        CGRect mainrect = [[UIScreen mainScreen] bounds];
        //CGRect newRect = CGRectMake(0, mainrect.size.height, mainrect.size.width, mainrect.size.height);
        [UIView animateWithDuration:0.8
                animations:^{
                    self.transparentModalViewController.view.alpha = 0;
                } completion:^(BOOL finished) {
            [self.transparentModalViewController.view removeFromSuperview];
            self.transparentModalViewController = nil;
        }];
    }


}

- (void)removeLoadingView
{
    [UIView animateWithDuration:0.8 animations:^{
        _loadingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_loadingView removeFromSuperview];
    }];
}
-(void)showLoadingView {
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height + 20)];
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

    _loadingView.alpha = 0;
    [self.view addSubview:_loadingView];
    [UIView animateWithDuration:0.8 animations:^{
        _loadingView.alpha = 0.8;
    } completion:^(BOOL finished) {
        //swag
    }];


}
- (void)refreshData
{
    _refresh.enabled = NO;
    [self showLoadingView];;
    [_data loadData];
}
@end

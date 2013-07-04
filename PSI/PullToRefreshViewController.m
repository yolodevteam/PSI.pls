//
//  PullToRefreshViewController.m
//  PSI
//
//  Created by Terence Tan on 4/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "PullToRefreshViewController.h"
#import "MainViewController.h"
#import "RegionViewController.h"
#import "SpiralPullToRefresh.h"
#import "UIImage+Tools.m"

@interface PullToRefreshViewController ()


@end

@implementation PullToRefreshViewController {
    MainViewController *_mainViewController;
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
    NSLog(@"swag swag swag");
    [super viewDidLoad];
    
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

    
    //setup pull to refresh
    
    [_scrollView addPullToRefreshWithActionHandler:^ {
        [self refresh];

    }];

    [_scrollView setContentSize:(CGSizeMake(320, (self.view.frame.size.height + 20)))];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = TRUE;
    _scrollView.showsHorizontalScrollIndicator = FALSE;
    _scrollView.showsVerticalScrollIndicator = FALSE;
    _scrollView.directionalLockEnabled = TRUE;

    _scrollView.pullToRefreshController.waitingAnimation = SpiralPullToRefreshWaitAnimationCircular;
    _scrollView.scrollEnabled = TRUE;

    _mainViewController  = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    [_scrollView addSubview:_mainViewController.view];
    // place the subview somewhere in the scrollview
    _mainViewController.view.frame = [[UIScreen mainScreen] bounds];
    NSLog(@"hola swag swag swag");
    _mainViewController.data = [[PSIData alloc] init];
    _mainViewController.data.delegate = self;
    [_mainViewController.data loadData];
    
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadingCompleted:(PSIData *)data {
    NSLog(@"LOADING COMPLETED GUYS!!! %@", data);
    for (RegionViewController *region in _mainViewController.pagesContainer.viewControllers) {
        NSLog(@"title %@", region.title);
        [region setData:data];
    }
    [_scrollView.pullToRefreshController didFinishRefresh];
}

-(void)refresh {
    NSLog(@"yolo swag 23=294394-3858 pulled!");
    [_mainViewController.data loadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGPoint offset = sender.contentOffset;
    if (sender.contentOffset.y > 0) {
        offset.y = 0;
    }
    else {
        offset.y = 0.9998 * sender.contentOffset.y;
    }
    sender.contentOffset = offset;

}
@end

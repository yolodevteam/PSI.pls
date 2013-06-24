//
//  ViewController.h
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graph.h"

@interface ViewController : UIViewController <NSURLConnectionDataDelegate, UIScrollViewDelegate>
{
    BOOL canRedraw;
    BOOL fromRefresh;
    NSTimer *redrawTimer;
    BOOL tappedPSI;
    NSMutableDictionary* PSIs;
}


@property int hour;
@property (nonatomic, strong) NSDictionary *results;
@property (nonatomic, strong) IBOutlet UILabel *psiLabel;
@property (nonatomic, strong) IBOutlet UILabel *psiRegion;
@property (nonatomic, strong) IBOutlet UILabel *pm25Region;

@property (nonatomic, strong) IBOutlet UILabel *health;
@property (nonatomic, strong) NSString *hourString;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) IBOutlet UILabel *time;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIButton *info;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) IBOutlet UIScrollView *graphView;
@property (nonatomic, strong) IBOutlet UIButton *refresh;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *act;
@property (nonatomic, strong) IBOutlet UIPageControl* pageControl;
@property BOOL loading;

@end

//
//  ViewController.h
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graph.h"

#define IS_4INCH_SCREEN (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)

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
@property (nonatomic, strong) IBOutlet UILabel *psiRegionLabel;
@property (nonatomic, strong) IBOutlet UILabel *pm25Region;
@property (nonatomic, strong) IBOutlet UILabel *pm25RegionLabel;

@property (nonatomic, strong) IBOutlet UILabel *psiDetail;
@property (nonatomic, strong) IBOutlet UILabel *psiDetailLabel;
@property (nonatomic, strong) IBOutlet UILabel *pm25Detail;
@property (nonatomic, strong) IBOutlet UILabel *pm25DetailLabel;




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
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIButton *errorRefresh;



@end

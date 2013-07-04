//
//  PullToRefreshViewController.h
//  PSI
//
//  Created by Terence Tan on 4/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSIData.h"


#define IS_4INCH_SCREEN (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)

@interface PullToRefreshViewController : UIViewController<PSIDataDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;

@end

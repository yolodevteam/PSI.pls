//
//  MainViewController.h
//  PSI
//
//  Created by Terence Tan on 1/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSIData.h"
#import "DAPagesContainer.h"
#import "InformationViewController.h"
#import <CoreLocation/CoreLocation.h>

@class PSIData;


#define IS_4INCH_SCREEN (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)


@interface MainViewController : UIViewController<PSIDataDelegate, InformationViewControllerDelegate, CLLocationManagerDelegate>  {
    

}


@property (nonatomic, strong) IBOutlet UIView *pagesView;
@property (nonatomic, strong) IBOutlet UIButton *refresh;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) UIView* loadingView;
@property (nonatomic, strong) UILabel* errorLabel;
@property (nonatomic, strong) UIButton *errorRefresh;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *act;
@property (nonatomic, strong) UIViewController* transparentModalViewController;
@property (nonatomic, strong) PSIData *data;

@property (nonatomic, strong) CLLocationManager* locationManager;

@property (strong, nonatomic) DAPagesContainer *pagesContainer;

@property (nonatomic, strong) IBOutlet UIButton *info;

@end

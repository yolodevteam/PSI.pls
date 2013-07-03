//
//  MainViewController.h
//  PSI
//
//  Created by Terence Tan on 1/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>


#define IS_4INCH_SCREEN (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)

@interface MainViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *pagesView;
@property (nonatomic, strong) IBOutlet UIButton *refresh;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *act;


@property (nonatomic, strong) IBOutlet UIButton *info;

@end

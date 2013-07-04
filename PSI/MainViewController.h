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

@class PSIData;




@interface MainViewController : UIViewController  {

}


@property (nonatomic, strong) IBOutlet UIView *pagesView;
@property (nonatomic, strong) IBOutlet UIButton *refresh;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *act;
@property (nonatomic, strong) PSIData *data;

@property (strong, nonatomic) DAPagesContainer *pagesContainer;

@property (nonatomic, strong) IBOutlet UIButton *info;

@end

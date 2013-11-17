//
//  RegionViewController.h
//  PSI
//
//  Created by Terence Tan on 3/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataViewController.h"
#import "HealthInfoViewController.h"
#import "MainViewController.h"


@interface RegionViewController : DataViewController {
    NSDictionary* regionDictionary;
}

@property (nonatomic, strong) IBOutlet UILabel* psiValue;
@property (nonatomic, strong) IBOutlet UILabel* psiHealth;
@property (nonatomic, strong) IBOutlet UILabel* pm25Value;
@property (nonatomic, strong) IBOutlet UILabel* pm25Health;

@property (nonatomic, strong) IBOutlet UILabel* pm25Label;
@property (nonatomic, strong) IBOutlet UILabel* ozoneLabel;
@property (nonatomic, strong) IBOutlet UILabel* no3Label;
@property (nonatomic, strong) IBOutlet UILabel* pm10Label;
@property (nonatomic, strong) IBOutlet UILabel* so2Label;
@property (nonatomic, strong) IBOutlet UILabel* coLabel;

@property (nonatomic, strong) NSString* region;
@property (nonatomic, strong) HealthInfoViewController* infoView;
@property (nonatomic, strong) MainViewController* mainView;



@end


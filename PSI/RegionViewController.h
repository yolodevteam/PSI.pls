//
//  RegionViewController.h
//  PSI
//
//  Created by Terence Tan on 3/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataViewController.h"

@interface RegionViewController : DataViewController

@property (nonatomic, strong) IBOutlet UILabel* psiValue;
@property (nonatomic, strong) IBOutlet UILabel* psiHealth;
@property (nonatomic, strong) IBOutlet UILabel* pm25Value;
@property (nonatomic, strong) IBOutlet UILabel* pm25Health;

@property (nonatomic, strong) NSString* region;
@end


//
//  DataViewController.h
//  PSI
//
//  Created by Terence Tan on 3/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSIData.h"

@interface DataViewController : UIViewController

@property (nonatomic, strong) PSIData* data;

-(void)setData:(PSIData* )data;

@end

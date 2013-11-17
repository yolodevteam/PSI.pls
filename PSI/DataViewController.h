//
//  DataViewController.h
//  PSI
//
//  Created by Terence Tan on 3/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSIData.h"
#import "PollutantData.h"

@interface DataViewController : UIViewController

@property (nonatomic, strong) PSIData* data;
@property (nonatomic, strong) PollutantData* pollutantData;

-(void)setData:(PSIData* )data;
-(void)setPollutantData:(PollutantData*) data;
-(PollutantData*) getPollutantData;

@end

//
//  PullToRefresh.h
//  PSI
//
//  Created by Terence Tan on 4/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullToRefresh : UIScrollView

@property (nonatomic, strong) UIScrollView *scrollView;

-(void)addView:(UIView*) view;

@end

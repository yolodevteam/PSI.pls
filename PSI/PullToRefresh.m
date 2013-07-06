//
//  PullToRefresh.m
//  PSI
//
//  Created by Terence Tan on 4/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "PullToRefresh.h"
#import "SpiralPullToRefresh.h"

@implementation PullToRefresh

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)addView:(UIView *)view {
    [self addSubview:view];
    self.pagingEnabled = TRUE;
    self.showsHorizontalScrollIndicator = FALSE;
    self.showsVerticalScrollIndicator = FALSE;
    self.directionalLockEnabled = TRUE;
    self.pullToRefreshController.waitingAnimation = SpiralPullToRefreshWaitAnimationCircular;
    self.scrollEnabled = TRUE;
    [self addPullToRefreshWithActionHandler:^ {
        [self refresh];

    }];
    self.contentSize = CGSizeMake(320, (self.frame.size.height + 20));

}
-(void) refresh {
    NSLog(@"yolo swag refreshed");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

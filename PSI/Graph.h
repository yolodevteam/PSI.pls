//
//  Graph.h
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSIData.h"

#define IS_4INCH_SCREEN (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)

#define _kGraphHeight 154
#define kGraphWidth 620
#define kOffsetX 0// this needs to change to offset the graph to the right. Is 1 because line is 0.7 else clipping would occur
#define kStepX 13.913  // grid lines #math
#define kStepY 10
#define kOffsetY 10
#define _kGraphBottom 177
#define kGraphTop 0
#define kBarTop 10
#define kBarWidth 20
#define kCircleRadius 4
#define kTouchRadius 40
#define kNumberOfBars 20 // one per hour
#define kFontSize 15
#define kFont "Helvetica Neue Light"
#define kNumberOffset 3
#define kDetailFontSize 28
#define kDetailFont "Helvetica Neue Light"

int kGraphHeight, kGraphBottom;

@interface Graph : UIScrollView
{
    CGContextRef context;
}

-(id)initWithData:(PSIData*) data frame:(CGRect) frame controller:(UIViewController*) controller;
-(void)showPoint:(int) index;

@end
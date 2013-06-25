//
//  Graph.h
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

#define kGraphHeight 177
#define kGraphWidth 620
#define kOffsetX 1 // this needs to change to offset the graph to the right. Is 1 because line is 0.7 else clipping would occur
#define kStepX 53 // grid lines
#define kStepY 10
#define kOffsetY 10
#define kGraphBottom 200
#define kGraphTop 0
#define kBarTop 10  
#define kBarWidth 20
#define kCircleRadius 4
#define kTouchRadius 40
#define kNumberOfBars 24 // one per hour
#define kFontSize 17
#define kFont "Helvetica Neue Light"
#define kNumberOffset 2
#define kDetailFontSize 28
#define kDetailFont "Helvetica Neue UltraLight"

@interface Graph : UIScrollView
{
    CGContextRef context;
}

-(id)initWithData:(NSDictionary*) dictData frame:(CGRect) frame controller:(UIViewController*) controller;

@end

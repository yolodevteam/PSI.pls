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
#define kGraphWidth 900
#define kOffsetX 1 // this needs to change to offset the graph to the right. Is 1 because line is 0.7 else clipping would occur
#define kStepX 53 // grid lines
#define kStepY 10
#define kOffsetY 10
#define kGraphBottom 200
#define kGraphTop 0
#define kBarTop 10  
#define kBarWidth 20
#define kCircleRadius 2
#define kTouchRadius 40
#define kNumberOfBars 24 // one per hour
#define kFontSize 28
#define kFont "Helvetica Neue UltraLight"
#define kNumberOffset 2

@interface Graph : UIScrollView

-(id)initWithData:(NSDictionary*) dictData withFrame:(CGRect) frame withController:(UIViewController*) controller;

@end

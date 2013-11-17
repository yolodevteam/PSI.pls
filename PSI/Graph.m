//
//  Graph.m
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "Graph.h"
//#import <Accelerate/Accelerate.h>

@implementation Graph {
    NSArray* psiValues;
    CGRect _rect;
    PSIData *_data;
    int newPointPos;
    
}
float data[24];
float scale;
float highest = 0;
int average;
BOOL newPoint = NO;
CGFloat dash[] = {3,2};
CGFloat dashNormal[1]={1};



CGRect touchesAreas[kNumberOfBars];

#warning be aware to get accurate data points all values in data[] need to be multiplied by 3 for scale


-(id)initWithData:(PSIData*) data frame:(CGRect) frame controller:(UIViewController*) controller {
    self = [super initWithFrame:frame];
    _data = data;
    if (IS_4INCH_SCREEN) {
        kGraphBottom = _kGraphBottom + 61;
        kGraphHeight = _kGraphHeight + 88;
    }
    else {
        kGraphBottom = _kGraphBottom;
        kGraphHeight = _kGraphHeight;
    }
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        psiValues = data.sortedResults;
    }
    NSLog(@"sorted results bro, %@", data.sortedResults);
    for (NSString* psi_s in data.sortedResults) {
        if ([psi_s integerValue] > highest) {
            highest = [psi_s floatValue];
            
        }
    }
    NSLog(@"highest %lf", highest);
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    int maxGraphHeight = kGraphHeight - kOffsetY;
    // Setup code
    context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, rect);
    
    
    // Clear background
    
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] CGColor]);
    
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    // Verticle lines (time stamp)
    int numVertLines = 24;
    for (int i = 0; i < numVertLines; i++) {
        CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphTop);
        if (i == 2 || i == 6 || i == 10|| i == 14 || i == 18 || i == 22) {
            CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphBottom);
        }
        
    }
    CGContextStrokePath(context);
    CGContextSetLineDash(context, 0,dashNormal,0);
    
    
    
    
    // Line graph line
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    
    
    
    CGContextBeginPath(context);
    
    
    float scaled;
    //NSLog(@"psi values %@", psiValues);
    for (int i = 0; i < kNumberOfBars; i++) {
        scaled = ([[psiValues objectAtIndex:i] floatValue]/highest) / 3;
        //NSLog(@"da scaled %f", scaled);
        if (i == 0) {
            CGContextMoveToPoint(context, kOffsetX, kGraphHeight - (maxGraphHeight * scaled));
        } else {
            CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * scaled);
        }
    }
    
    CGContextDrawPath(context, kCGPathStroke);
    
    // Points on the line graph
    int value;
    float alpha = 0.7;
    
    UIColor* pointColor;
    
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithWhite:1 alpha:0.6] CGColor]);
    for (int i = 0; i < kNumberOfBars; i++) {
        if ((newPoint == YES) && (i == newPointPos)) {
            value = [[psiValues objectAtIndex:i] integerValue];
            scaled = ([[psiValues objectAtIndex:i] floatValue]/highest) / 3;
            pointColor = [self getPointColorForPSI:value withAlpha:0.9];
            CGContextSetFillColorWithColor(context, [pointColor CGColor]);
            
            float x = kOffsetX + i * kStepX;
            float y = kGraphHeight - maxGraphHeight * scaled;
            
            CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
            CGContextAddEllipseInRect(context, rect);
            CGContextSetShadowWithColor(context, CGSizeMake(1, 1), 5 , [[UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1.0] CGColor]);
            CGContextDrawPath(context, kCGPathFillStroke);
            
        }
    }
    CGContextSetShadow(context, CGSizeMake(0, 0), 0);
    
    
    
    alpha = 0.13;
    pointColor = [self getPointColorForPSI:value withAlpha:alpha];
    CGContextSetFillColorWithColor(context, [pointColor CGColor]);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, kOffsetX, kGraphHeight);
    for (int i = 0; i < kNumberOfBars; i++) {
        scaled = ([[psiValues objectAtIndex:i] floatValue]/highest) / 3;
        CGContextAddLineToPoint(context, kOffsetX + (i * kStepX), kGraphHeight - (maxGraphHeight * scaled));
    }
    
    CGContextAddLineToPoint(context, kOffsetX + (sizeof(data) - 1) * kStepX, kGraphHeight);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    
    //selection points
    CGContextSetLineWidth(context, 1.6);
    CGContextSetShadowWithColor(context, CGSizeMake(1, 1), 5 , [[UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1.0] CGColor]);
    
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    for (int i = 0; i < kNumberOfBars; i++) {
        if ((newPoint == YES) && (i == newPointPos)) {
            value = [[psiValues objectAtIndex:i] integerValue];
            scaled = ([[psiValues objectAtIndex:i] floatValue]/highest) / 3;
            pointColor = [self getPointColorForPSI:value withAlpha:0.9];
            CGContextSetFillColorWithColor(context, [pointColor CGColor]);
            
            float x = kOffsetX + i * kStepX;
            float y = kGraphHeight - maxGraphHeight * scaled;
            
            CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
            CGContextAddEllipseInRect(context, rect);
            CGContextDrawPath(context, kCGPathFillStroke);
            
        }
    }
    CGContextSetShadow(context, CGSizeMake(0, 0), 0);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
    CGContextSetLineWidth(context, 0.6);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:1 alpha:0.75] CGColor]);
    CGContextMoveToPoint(context, 0, kGraphHeight);
    CGContextAddLineToPoint(context, 320, kGraphHeight);
    CGContextStrokePath(context);
    
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSelectFont(context, kFont, kFontSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8] CGColor]);
    NSString* suffix;
    NSString* hourString;
    float hourAlpha = 0.65;
    
    for (int i = 0; i < kNumberOfBars; i++) {
        
        if (i == 2 || i == 6 || i == 10|| i == 14 || i == 18) {
            // Text at bottom
            
            NSArray* split = [[_data.sortedKeys objectAtIndex:i] componentsSeparatedByString:@":"];
            int hour = [split[2] integerValue];
            
            if (hour == 0) {
                suffix = @"am";
                hourString = [NSString stringWithFormat:@"%d", 12];
            }
            else if (hour > 12) {
                hourString = [NSString stringWithFormat:@"%d", hour-12];
                suffix = @"pm";
            }
            else {
                suffix = @"am";
                if (hour == 12) {
                    suffix = @"pm";
                }
                hourString = [NSString stringWithFormat:@"%d", hour];
            }
            
            hourString = [NSString stringWithFormat:@"%@%@", hourString, suffix];
            
            CGContextShowTextAtPoint(context, kOffsetX + (i * kStepX) + kNumberOffset, kGraphBottom - 5, [hourString cStringUsingEncoding:NSUTF8StringEncoding], [hourString length]);
            
        }
        
    }
}
-(void)showPoint:(int) index {
    newPointPos = index;
    newPoint = YES;
    [self setNeedsDisplay];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    for (int i = 0; i < kNumberOfBars; i++) {
        if (CGRectContainsPoint(touchesAreas[i], point)) {
            
            
            break;
        }
    }
}
-(UIColor*) getPointColorForPSI:(int) value withAlpha:(float)alpha{
    UIColor* pointColor;
    if (value < 51) {
        // 'Good'
        pointColor = [UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:alpha];
    }
    else if (value < 101) {
        pointColor = [UIColor colorWithRed:0.827 green:0.329 blue:0 alpha:alpha];
    }
    else if (value < 201) {
        pointColor = [UIColor colorWithRed:0.953 green:0.612 blue:0.071 alpha:alpha];
    }
    else if (value < 300) {
        pointColor = [UIColor colorWithRed:0.753 green:0.224 blue:0.169 alpha:alpha];
    }
    else if (value >= 300){
        pointColor = [UIColor colorWithRed:0.608 green:0.349 blue:0.714 alpha:alpha];
    }
    return pointColor;
}
@end
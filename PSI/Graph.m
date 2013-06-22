//
//  Graph.m
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "Graph.h"

@implementation Graph

float data[] = {0.7, 0.4, 0.9, 1.0, 0.2, 0.85, 0.11, 0.75, 0.53, 0.44, 0.88, 0.77};

CGRect touchesAreas[kNumberOfBars];

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
        if (self) {
            // Initialization code
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Setup code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    // Verticle lines (time stamp)
    int numVertLines = (kGraphWidth - kOffsetX / kStepX);
    
    for (int i = 0; i < numVertLines; i++) {
        CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphBottom);
    }
    
    CGContextStrokePath(context);
    
    // Line graph line
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    int maxGraphHeight = kGraphHeight - kOffsetY;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kOffsetX, kGraphHeight - maxGraphHeight * data[0]);
    
    for (int i = 0; i < sizeof(data)/sizeof(float); i++) {
        CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * data[i]);
    }
    
    CGContextDrawPath(context, kCGPathStroke);
    
    // Points on the line graph
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    //for (int i = 0; i < sizeof(data) - 1; i++){
    for (int i = 0; i < kNumberOfBars; i++) {
        float x = kOffsetX + i * kStepX;
        float y = kGraphHeight - maxGraphHeight * data[i];
        
        CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
        CGRect touchPoint = CGRectMake(x - kTouchRadius, y - kTouchRadius, 2 * kTouchRadius, 2 * kTouchRadius);
        
        CGContextAddEllipseInRect(context, rect);
        
        touchesAreas[i] = touchPoint;
        
        /*CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
        CGContextSelectFont(context, kFont, kFontSize, kCGEncodingMacRoman);
        CGContextSetTextDrawingMode(context, kCGTextFill);
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        
        for (int i = 0; i < kNumberOfBars; i++) {
            NSString *text = [NSString stringWithFormat:@"%d", i];
            CGContextShowTextAtPoint(context, kOffsetX + i * kStepX, kGraphBottom - 7, [text cStringUsingEncoding:NSUTF8StringEncoding], [text length]);
        }*/
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // Fill under graph - left incase you want it ttwj
    
    /*CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] CGColor]);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, kOffsetX, kGraphHeight);
    CGContextAddLineToPoint(context, kOffsetX, kGraphHeight - maxGraphHeight * data[0]);
    
    for (int i = 0; i < sizeof(data)/sizeof(float); i++) {
        CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * data[i]);
    }
    
    CGContextAddLineToPoint(context, kOffsetX + (sizeof(data) - 1) * kStepX, kGraphHeight);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);*/
    
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSelectFont(context, kFont, kFontSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    for (int i = 0; i < kNumberOfBars; i++) {
        NSString *text = [NSString stringWithFormat:@"%d", i];
        CGContextShowTextAtPoint(context, kOffsetX + i * kStepX + kNumberOffset, kGraphBottom - 5, [text cStringUsingEncoding:NSUTF8StringEncoding], [text length]);
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    for (int i = 0; i < kNumberOfBars; i++) {
        if (CGRectContainsPoint(touchesAreas[i], point)) {
            NSLog(@"Tapped point with index %d, value %f", i, data[i]);
            break;
        }
    }
}

/*- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    // verticle time stamps
    int numVertLines = (kGraphWidth - kOffsetX / kStepX);
    
    for (int i = 0; i < numVertLines; i++) {
        CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphBottom);
    }
    
    CGContextStrokePath(context);
}*/

- (void)drawBar:(CGRect)rect context:(CGContextRef)context
{
    // make one bar
    CGContextBeginPath(context);
    CGContextSetGrayFillColor(context, 1, 0.8); // fill for the bar
    
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    
    CGContextFillPath(context);
    
    // Actually draw the bars
    float maxBarHeight = kGraphHeight - kBarTop - kOffsetY;
    
    for (int i = 0; i < sizeof(data)/sizeof(float); i++) {
        float barX = kOffsetX + kStepX + i * kStepX - kBarWidth / 2;
        float barY = kBarTop + maxBarHeight - maxBarHeight * data[i];
        float barHeight = maxBarHeight * data[i];
        
        CGRect barRect = CGRectMake(barX, barY, kBarWidth, barHeight);
        
        [self drawBar:barRect context:context];
        
    }

}


@end

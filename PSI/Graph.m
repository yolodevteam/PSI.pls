//
//  Graph.m
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "Graph.h"

@implementation Graph
float data[24];
float scale;
float highest = 0;

CGRect touchesAreas[kNumberOfBars];

#warning be aware to get accurate data points all values in data[] need to be multiplied by 3 for scale

-(id)initWithData:(NSDictionary*)dictData frame:(CGRect) frame controller:(ViewController*) controller {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];

        NSMutableArray* keys = [NSMutableArray arrayWithCapacity:24];
    
        for (int i = 0; i < 24; i++) {
            NSString* _hourString = [NSString stringWithFormat:@"%d", i];
            
            if ([_hourString length] == 1) {
                _hourString = [NSString stringWithFormat:@"0%d", i];
            }
            
            int value = [[dictData objectForKey:_hourString] intValue];
            
            if (value > highest ) {
                highest = value + 20;
            }
            
            [keys addObject:[dictData objectForKey:_hourString]];
        }
        
        int i = 0;
        
        for (id value in keys) {
            float scaled = ([value floatValue]/highest) / 3;
            data[i] = scaled;
            i++;
        }
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Setup code
    context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, rect);

    
    // Clear background
    
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);

    
    // Verticle lines (time stamp)
    int numVertLines = 24;
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
        if (data[i] == 0) {
            break;
        } else {
            CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * data[i]);
        }
    }
    
    CGContextDrawPath(context, kCGPathStroke);
    
    // Points on the line graph
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    for (int i = 0; i < kNumberOfBars; i++) {
        float x = kOffsetX + i * kStepX;
        float y = kGraphHeight - maxGraphHeight * data[i];
        
        if (data[i] == 0) {
            break;
        } else {
            CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
            CGRect touchPoint = CGRectMake(x - kTouchRadius, y - kTouchRadius, 2 * kTouchRadius, 2 * kTouchRadius);
            
            CGContextAddEllipseInRect(context, rect);
            
            touchesAreas[i] = touchPoint;
        }
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSelectFont(context, kFont, kFontSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    for (int i = 0; i < kNumberOfBars; i++) {
        CGContextSelectFont(context, kFont, kFontSize, kCGEncodingMacRoman);

        // Text at bottom
        NSString *value = [NSString stringWithFormat:@"%d", i];
        CGContextShowTextAtPoint(context, kOffsetX + i * kStepX + kNumberOffset, kGraphBottom - 5, [value cStringUsingEncoding:NSUTF8StringEncoding], [value length]);
        
        if (data[i] == 0){
            continue;
        } else {
            
            CGContextSelectFont(context, kFont, 22, kCGEncodingMacRoman);

            
            // Text at data point
            int number = (data[i] * highest) * 3;
            NSString *detailText = [NSString stringWithFormat:@"%d", number];
        
            CGContextShowTextAtPoint(context, kOffsetX + i * kStepX + kNumberOffset, kGraphHeight - maxGraphHeight * data[i] - 5, [detailText cStringUsingEncoding:NSUTF8StringEncoding], [detailText length]);
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    for (int i = 0; i < kNumberOfBars; i++) {
        if (CGRectContainsPoint(touchesAreas[i], point)) {
            NSLog(@"Tapped point with index %d, value %f", i, (data[i] * highest) * 3);
            
            
            
            
            
            break;
        }
    }
}

@end

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
    NSMutableArray* psiValues;
    PSIData *_data;
}
float data[24];
float scale;
float highest = 0;

CGRect touchesAreas[kNumberOfBars];

#warning be aware to get accurate data points all values in data[] need to be multiplied by 3 for scale


-(id)initWithData:(PSIData*) data frame:(CGRect) frame controller:(UIViewController*) controller {
    self = [super initWithFrame:frame];
    _data = data;
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        psiValues = [[NSMutableArray alloc] initWithCapacity:24];
        int psi;
        for (NSDictionary *dict in data.sortedResults) {
            psi = [[[dict objectForKey:@"psi"] objectForKey:@"3hr"] integerValue];
            if (psi > highest) {
                highest = psi;
            }
            [psiValues addObject:[NSNumber numberWithInt:psi]];
        }
        NSLog(@"PSISSSSS ###################### %@", psiValues);
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
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] CGColor]);
    CGFloat dash[] = {6, 4};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    // Verticle lines (time stamp)
    int numVertLines = 24;
    for (int i = 0; i < numVertLines; i++) {
        CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphTop);
        if (i == 0 || i == 4 || i == 8 | i == 12 || i == 16 || i == 20 || i == 24) {
            CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphBottom);
        }

    }
    float normal[1]={1};
    CGContextSetLineDash(context,0,normal,0);
    

    CGContextStrokePath(context);
    
    // Line graph line
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    
    int maxGraphHeight = kGraphHeight - kOffsetY;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kOffsetX, kGraphHeight - (maxGraphHeight * data[0]));

    float scaled;
    for (int i = 0; i < sizeof(data)/sizeof(float); i++) {
        scaled = ([[psiValues objectAtIndex:i] floatValue]/highest) / 3;
        NSLog(@"SCALED 420%%%%%%%%%%%%%%%%%^^^^^^^&^ %f", scaled);
        if (scaled == 0) {
            break;
        } else {
            CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * scaled);
        }
    }
    
    CGContextDrawPath(context, kCGPathStroke);
    
    // Points on the line graph
    int value;
    float alpha = 0.7;
    
    UIColor* pointColor;
    for (int i = 0; i < kNumberOfBars; i++) {
        value = [[psiValues objectAtIndex:i] integerValue];
        NSLog(@"da value %d", value);
        if (value < 51) {
            // 'Good'
            NSLog(@"good");
            pointColor = [UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:alpha];
        }
        else if (value < 101) {
            NSLog(@"moderate");
            pointColor = [UIColor colorWithRed:0.827 green:0.329 blue:0 alpha:alpha];
        }
        else if (value < 201) {
             NSLog(@"unhealthy");
            pointColor = [UIColor colorWithRed:0.953 green:0.612 blue:0.071 alpha:alpha];
        }
        else if (value < 300) {
             NSLog(@"very unhealthy");
            pointColor = [UIColor colorWithRed:0.753 green:0.224 blue:0.169 alpha:alpha];
        }
        else if (value >= 300){
             NSLog(@"yolo");
            pointColor = [UIColor colorWithRed:0.608 green:0.349 blue:0.714 alpha:alpha];
        }

        scaled = ([[psiValues objectAtIndex:i] floatValue]/highest) / 3;
        float x = kOffsetX + i * kStepX;
        float y = kGraphHeight - maxGraphHeight * scaled;
        
        if (scaled == 0) {
            break;
        } else {
            NSLog(@"data i %f %d", scaled, i);
            CGContextSetFillColorWithColor(context, [pointColor CGColor]);
            int radius = 0;
            if (i == 0 || i == 4 || i == 8 | i == 12 || i == 16 || i == 20 || i == 24) {
                radius = kCircleRadius;
            }
            CGRect rect = CGRectMake(x - radius, y - radius, 2 * radius, 2 * radius);
            CGRect touchPoint = CGRectMake(x - kTouchRadius, y - kTouchRadius, 2 * kTouchRadius, 2 * kTouchRadius);

            CGContextAddEllipseInRect(context, rect);
            CGContextDrawPath(context, kCGPathFillStroke);
            touchesAreas[i] = touchPoint;
        }
    }
    
    
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSelectFont(context, kFont, kFontSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8] CGColor]);
    
    NSString* suffix;
    for (int i = 0; i < kNumberOfBars; i++) {
        CGContextSelectFont(context, kDetailFont, kFontSize, kCGEncodingMacRoman);
        if (i == 0 || i == 4 || i == 8 | i == 12 || i == 16 || i == 20 || i == 24) {
            // Text at bottom
            NSArray* split = [[_data.sortedKeys objectAtIndex:i] componentsSeparatedByString:@":"];
            int hour = [split[2] integerValue];
            NSString *value;
            if (hour == 0) {
                suffix = @"am";
                value = [NSString stringWithFormat:@"%d", hour];
            }
            else if (hour > 12) {
                value = [NSString stringWithFormat:@"%d", hour-12];
                suffix = @"pm";
            }
            else {
                suffix = @"am";
                if (hour == 12) {
                    suffix = @"pm";
                }
                value = [NSString stringWithFormat:@"%d", hour];
            }

            value = [NSString stringWithFormat:@"%@%@", value, suffix];

            CGContextShowTextAtPoint(context, kOffsetX + i * kStepX + kNumberOffset, kGraphBottom - 5, [value cStringUsingEncoding:NSUTF8StringEncoding], [value length]);

            if (data[i] == 0){
                continue;
            } else {

                CGContextSelectFont(context, kFont, 22, kCGEncodingMacRoman);

                // Text at data point
                float number = ceil((data[i] * highest) * 3);
                NSString *detailText = [NSString stringWithFormat:@"%d", (int)roundf(number)];

                CGContextShowTextAtPoint(context, kOffsetX + i * kStepX + kNumberOffset, kGraphHeight - maxGraphHeight * data[i] - 5, [detailText cStringUsingEncoding:NSUTF8StringEncoding], [detailText length]);
            }
        }
    }
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

@end

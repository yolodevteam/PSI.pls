//
//  Graph.m
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "Graph.h"
#import <Accelerate/Accelerate.h>

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
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH";
        NSTimeZone *sgt = [NSTimeZone timeZoneWithAbbreviation:@"SGT"];
        [dateFormatter setTimeZone:sgt];
        
        int time = [[dateFormatter stringFromDate:[NSDate date]] integerValue];

        for (int i = 0; i < (time+1); i++) {
            NSString* _hourString = [NSString stringWithFormat:@"%d", i];

            if ([_hourString length] == 1) {
                _hourString = [NSString stringWithFormat:@"0%d", i];
            }
            
            int value = [[dictData objectForKey:_hourString] intValue];
            
            if (value > highest ) {
                highest = value + 20;
            }
            id obj = [dictData objectForKey:_hourString];
            if (!obj) {
                NSString* _hourString = [NSString stringWithFormat:@"%d", i-1];
                
                if ([_hourString length] == 1) {
                    _hourString = [NSString stringWithFormat:@"0%d", i-1];
                }
                obj = [dictData objectForKey:_hourString];
            }
            else {
                [keys addObject:obj];
            }
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
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] CGColor]);
    CGFloat dash[] = {6, 4};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    // Verticle lines (time stamp)
    int numVertLines = 24;
    for (int i = 0; i < numVertLines; i++) {
        CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphBottom);
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
    
    for (int i = 0; i < sizeof(data)/sizeof(float); i++) {
        if (data[i] == 0) {
            break;
        } else {
            CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * data[i]);
        }
    }
    
    CGContextDrawPath(context, kCGPathStroke);
    
    // Points on the line graph
    float value;
    
    UIColor* pointColor;
    for (int i = 0; i < kNumberOfBars; i++) {
        value = (data[i] * highest) * 3;
        NSLog(@"da value %f", value);
        if (value < 51) {
            // 'Good'
            NSLog(@"good");
            pointColor = [UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:1.0];
        }
        else if (value < 101) {
            NSLog(@"moderate");
            pointColor = [UIColor colorWithRed:0.827 green:0.329 blue:0 alpha:1.0];
        }
        else if (value < 201) {
             NSLog(@"unhealthy");
            pointColor = [UIColor colorWithRed:0.953 green:0.612 blue:0.071 alpha:1.0];
        }
        else if (value < 300) {
             NSLog(@"very unhealthy");
            pointColor = [UIColor colorWithRed:0.753 green:0.224 blue:0.169 alpha:1.0];
        }
        else if (value >= 300){
             NSLog(@"yolo");
            pointColor = [UIColor colorWithRed:0.608 green:0.349 blue:0.714 alpha:1.0];
        }
        CGContextSetFillColorWithColor(context, [pointColor CGColor]);

        float x = kOffsetX + i * kStepX;
        float y = kGraphHeight - maxGraphHeight * data[i];
        
        if (data[i] == 0) {
            break;
        } else {
            CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
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
        
        // Text at bottom
    
        NSString *value;
        if (i == 0) {
            suffix = @"am";
            value = [NSString stringWithFormat:@"%d", 12];
        }
        else if (i > 12) {
            value = [NSString stringWithFormat:@"%d", i-12];
            suffix = @"pm";
        }
        else {
            suffix = @"am";
            if (i == 12) {
                suffix = @"pm";
            }
            value = [NSString stringWithFormat:@"%d", i];
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

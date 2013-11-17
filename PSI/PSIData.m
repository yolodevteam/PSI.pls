//
//  PSIData.m
//  PSI
//
//  Created by Terence Tan on 3/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "PSIData.h"
#import "JSONKit.h"

@implementation PSIData

@synthesize responseData = _responseData;
@synthesize results = _results;
@synthesize sortedResults = _sortedResults;

-(void)loadData {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dawo.me/psi/psi.json"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Failed to load data: %@", error);
    
    
}
NSInteger customSort(id num1, id num2, void *context)
{
    NSArray* one_split = [num1 componentsSeparatedByString:@":"];
    int one = ([one_split[0] integerValue] * 24) + ([one_split[1] integerValue] * 30) + [one_split[2] integerValue];
    NSArray* two_split = [num2 componentsSeparatedByString:@":"];
    int two = ([two_split[0] integerValue] * 24) + ([two_split[1] integerValue] * 30) + [two_split[2] integerValue];
    //NSLog(@"two value %d", two);
    if (one < two)
        return NSOrderedAscending;
    else if (one > two)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Data recieved");
    _results = [_responseData objectFromJSONData];
   
    for (NSString *key in _results) {
        NSLog(@"time %@", key);
    }
    _sortedKeys = [[_results allKeys] sortedArrayUsingFunction:customSort context:NULL];
    //NSLog(@"sorted keys %@", _sortedKeys);
    _sortedResults = [_results objectsForKeys: _sortedKeys notFoundMarker: [NSNull null]];
     NSLog(@"result: %@", _sortedResults);
    [self.delegate loadingCompleted:self];
    NSLog(@"swaggie 2345");
}
-(NSString*) getLastHourData {
    return [_sortedResults lastObject];
}
-(int) getLastHour {
    id lastKey = [_sortedKeys lastObject];
    NSArray* split = [lastKey componentsSeparatedByString:@":"];
    return [split[2] integerValue];
}

UIColor* getColorFromPSI(int PSI, float alpha) {
    if (PSI < 51) {
        // 'Good'
        return [UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:alpha];
    }
    else if (PSI < 101) {
        return [UIColor colorWithRed:0.827 green:0.329 blue:0 alpha:alpha];
    }
    else if (PSI < 201) {
        return [UIColor colorWithRed:0.953 green:0.612 blue:0.071 alpha:alpha];
    }
    else if (PSI < 300) {
        return [UIColor colorWithRed:0.753 green:0.224 blue:0.169 alpha:alpha];
    }
    else if (PSI >= 300){
        return [UIColor colorWithRed:0.608 green:0.349 blue:0.714 alpha:alpha];
    }
    
    return [UIColor clearColor];
    
}

NSString* getHealthFromPSI(int PSI) {
    NSString* text;
    if (PSI < 51) {
        // 'Good'
        text = @"Good";
    }
    else if (PSI < 101) {
        text = @"Moderate";
    }
    else if (PSI < 201) {
        text = @"Unhealthy";
    }
    else if (PSI < 300) {
        text = @"Very unhealthy";
    }
    else if (PSI >= 300){
        text = @"Hazardous";
    }
    return text;
}

NSString* getHealthFromAQI(int AQI)
{
    NSString* text;
    if (AQI < 51) {
        // 'Good'
        text = @"Good";
    }
    else if (AQI < 101) {
        text = @"Moderate";
    }
    else if (AQI < 151) {
        text = @"Unhealthy for sensitive groups";
    }
    else if (AQI < 201) {
        text = @"Unhealthy";
    }
    else if (AQI < 300) {
        text = @"Very unhealthy";
    }
    else if (AQI >= 300){
        text = @"Hazardous";
    }
    return text;
}

int getAQIfromPM25(float PM25) {
    int AQILow, AQIHigh, AQI;
    float breakPointLow, breakPointHigh;
    if (PM25 < 12.1) {
        AQILow = 0;
        AQIHigh = 50;
        breakPointLow = 0.0;
        breakPointHigh = 12.0;
    }
    else if (PM25 < 35.5) {
        AQILow = 51;
        AQIHigh = 100;
        breakPointLow = 12.1;
        breakPointHigh = 35.4;
    }
    else if (PM25 < 55.5) {
        AQILow = 101;
        AQIHigh = 150;
        breakPointLow = 35.5;
        breakPointHigh = 55.4;
    }
    else if (PM25 < 150.5) {
        AQILow = 151;
        AQIHigh = 200;
        breakPointLow = 55.5;
        breakPointHigh = 150.4;
    }
    else if (PM25 < 250.5) {
        AQILow = 201;
        AQIHigh = 300;
        breakPointLow = 150.5;
        breakPointHigh = 250.4;
    }
    else if (PM25 < 350.5) {
        AQILow = 301;
        AQIHigh = 400;
        breakPointLow = 250.5;
        breakPointHigh = 350.4;
    }
    else {
        AQILow = 401;
        AQIHigh = 500;
        breakPointLow = 350.5;
        breakPointHigh = 500.4;
    }
    AQI = ceil((((AQIHigh-AQILow)/(breakPointHigh-breakPointLow)) * (PM25 - breakPointLow)) + AQILow);
    //NSLog(@"AQI %d, %d %d, %f", AQI, AQILow, AQIHigh, PM25);
    return AQI;
}
UIColor* getColorFromAQI(int AQI){
    float alpha = 0.68;
    
    if (AQI < 51) {
        //green
        //NSLog(@"green");
        return [UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:alpha];
    }
    else if (AQI < 101) {
        //yellow
        //NSLog(@"yellow");
        return [UIColor colorWithRed:0.945 green:0.769 blue:0.059 alpha:alpha];
    }
    else if (AQI < 151) {
        //NSLog(@"orange");
        return [UIColor colorWithRed:0.827 green:0.329 blue:0 alpha:alpha];
    }
    else if (AQI < 201) {
        //NSLog(@"red..");
        return [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:alpha];
    }
    else if (AQI < 301) {
        //NSLog(@"purple");
        return [UIColor colorWithRed:0.557 green:0.267 blue:0.678 alpha:alpha];
    }
    else {
        //NSLog(@"maroon");
        return [UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:alpha];
    }
}
@end
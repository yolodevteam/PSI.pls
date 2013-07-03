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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dawo.me/psi/all.json"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
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
    sortedKeys = [[_results allKeys] sortedArrayUsingFunction:customSort context:NULL];
    _sortedResults = [_results objectsForKeys: sortedKeys notFoundMarker: [NSNull null]];
    [_delegate loadingCompleted:self];
}
-(NSDictionary *) getLastHourData {
    return [_sortedResults lastObject];
}
-(int) getLastHour {
    id lastKey = [sortedKeys lastObject];
    NSArray* split = [lastKey componentsSeparatedByString:@":"];
    return [split[2] integerValue];
}

@end

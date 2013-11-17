#import "PollutantData.h"
#import "PSIData.h"
#import "JSONKit.h"

@implementation PollutantData

@synthesize responseData = _responseData;
@synthesize results = _results;
@synthesize sortedResults = _sortedResults;

-(void)loadData {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dawo.me/psi/all.json"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"loading pollutant data");
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Data recieved");
    _results = [_responseData objectFromJSONData];
    //NSLog(@"result: %@", _results);
    /*for (NSString *key in _results) {
        NSLog(@"time %@", key);
    }*/
    _sortedKeys = [[_results allKeys] sortedArrayUsingFunction:customSort context:NULL];
    //NSLog(@"sorted keys %@", _sortedKeys);
    _sortedResults = [_results objectsForKeys: _sortedKeys notFoundMarker: [NSNull null]];
    [self.delegate loadingPollutantsCompleted:self];
    NSLog(@"swaggie 2345");
}
-(NSArray *) getLastHourData {
    return [_sortedResults lastObject];
}
-(int) getLastHour {
    id lastKey = [_sortedKeys lastObject];
    NSArray* split = [lastKey componentsSeparatedByString:@":"];
    return [split[2] integerValue];
}

@end

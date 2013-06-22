//
//  ViewController.m
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize results = _results;
@synthesize hour = _hour;
@synthesize psiLabel = _psiLabel;
@synthesize hourString = _hourString;
@synthesize responseData = _responseData;
@synthesize time = _time;
@synthesize scrollView = _scrollView;
@synthesize health = _health;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"Init viewDidLoad");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dawo.me/psi/psi.json"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    _psiLabel.text = @"0";
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
    NSLog(@"JSON data recieved");
    
    NSError *err;
    
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:&err];

    if (err) {
        NSLog(@"There was an error reading JSON data: %@", err);
        return;
    }
    
    _results = results;
        
    NSString *date = [self getSingaporeTime];
    
    int hour = [date intValue];
        
    if ([[_results objectForKey:[NSString stringWithFormat:@"%d", hour]] isEqual: @"0"]) {
        // The NEA are being slow and haven't updated their figures yet, show latest figure.
        _hour = hour--;
        _hourString = [NSString stringWithFormat:@"%d", _hour];
    } else {
        _hour = hour;
        _hourString = [NSString stringWithFormat:@"%d", _hour];
        
        _psiLabel.text = [NSString stringWithFormat:@"%@", [_results objectForKey:_hourString]];
        _time.text = [NSString stringWithFormat:@"%d:00", _hour];
    }

    if ([_psiLabel.text isEqualToString:@"0"]) {
        _psiLabel.font = [UIFont fontWithName:@"Helvetica Neue UltraLight" size:30];
        _psiLabel.text = @"Current data unavaliable";
        _time.text = [NSString stringWithFormat:@"%d:00", _hour];
    } else {
        _psiLabel.text = [NSString stringWithFormat:@"%@", [_results objectForKey:_hourString]];
        _time.text = [NSString stringWithFormat:@"%d:00", _hour];
    }

    if (_hour > 20 || _hour < 7) {
        // Set a night time background picture (this is only if we can't get webcam images before release)
    }
}

- (void)updateLabels
{
    _psiLabel.text = [NSString stringWithFormat:@"%@", [_results objectForKey:_hourString]];
    _time.text = [NSString stringWithFormat:@"%d:00", _hour];
    
    
}

- (NSString *)getSingaporeTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH";
    
    NSTimeZone *sgt = [NSTimeZone timeZoneWithAbbreviation:@"SGT"];
    [dateFormatter setTimeZone:sgt];
    
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    
    return time;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ViewController.m
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "ViewController.h"
#import "InformationViewController.h"
#import "UIImage+Tools.m"
#import <QuartzCore/QuartzCore.h>

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
@synthesize info = _info;
@synthesize loadingView = _loadingView;
@synthesize graphView = _graphView;
@synthesize refresh = _refresh;
@synthesize act = _act;
@synthesize loading = _loading;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"Init viewDidLoad");
    //background swag
    UIImage *img = [[UIImage imageNamed:@"bg_iphone.jpg"] imageWithGaussianBlur];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dawo.me/psi/psi.json"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    _psiLabel.text = @"0";
    
    [_info addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _loadingView.backgroundColor = [UIColor blackColor];
    
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    act.center = _loadingView.center;
    
    [_loadingView addSubview:act];
    [act startAnimating];
        
    [self.view addSubview:_loadingView];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkTime) userInfo:nil repeats:YES];
    [timer fire];
    
    UIColor *color = _refresh.currentTitleColor;
    _refresh.titleLabel.layer.shadowColor = [color CGColor];
    _refresh.titleLabel.layer.shadowRadius = 4.0f;
    _refresh.titleLabel.layer.shadowOpacity = 0.9;
    _refresh.titleLabel.layer.shadowOffset = CGSizeZero;
    _refresh.titleLabel.layer.masksToBounds = YES;
    _refresh.showsTouchWhenHighlighted = YES;
    
    [_refresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
    
    fromRefresh = NO;
}

- (void)refreshData
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dawo.me/psi/psi.json"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // Animation block, fade all but time out lessen the blur while loading.
    _act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _act.center = self.view.center;
    _act.alpha = 0.0;
    [self.view addSubview:_act];
    [_act startAnimating];
    
    _refresh.enabled = NO;

    
    [UIView animateWithDuration:1.0 animations:^{
        _psiLabel.alpha = 0.0;
        _health.alpha = 0.0;
        _graphView.alpha = 0.0;
        _act.alpha = 1.0;
        _refresh.alpha = 0.0;
    } completion:^(BOOL finished) {
        canRedraw = YES;
        fromRefresh = YES;
    }];
}

- (void)redrawInterface
{
    while (true) {
        if (canRedraw == YES) {
            break;
        }
    }
    _refresh.enabled = YES;
    
    [UIView animateWithDuration:1.0 animations:^{
        _psiLabel.alpha = 1.0;
        _health.alpha = 1.0;
        _graphView.alpha = 1.0;
        _act.alpha = 0.0;
        _refresh.alpha = 1.0;
    } completion:^(BOOL finished){
        [_act removeFromSuperview];
    }];
}

- (void)checkTime
{
    _time.text = [self getSingaporeTimeWithMinutes:YES];
}

- (void)showInfo
{
    InformationViewController *info = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
    info.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentModalViewController:info animated:YES];
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
    //NSLog(@"%@", results);
    if (err) {
        NSLog(@"There was an error reading JSON data: %@", err);
        return;
    }
    
    _results = results;
        
    NSString *date = [self getSingaporeTimeWithMinutes:NO];
    
    int hour = [date intValue];
    
    _hour = hour;
     _hourString = [NSString stringWithFormat:@"%d", _hour];
    if ([_hourString length] == 1) {
        _hourString = [NSString stringWithFormat:@"0%d", _hour];
    }
        
    if ([[NSString stringWithFormat:@"%@", [_results objectForKey:_hourString]] isEqual: @"0"]) {
        // The NEA are being slow and haven't updated their figures yet, show latest figure.
        _hour--;
        _hourString = [NSString stringWithFormat:@"%d", _hour];
        if ([_hourString length] == 1) {
            _hourString = [NSString stringWithFormat:@"0%@", _hourString];
        }
    }
    
    if ([[_results objectForKey:[NSString stringWithFormat:@"%d", (hour - 1)]] isEqual: @"0"]) {
        _psiLabel.font = [UIFont fontWithName:@"Helvetica Neue UltraLight" size:30];
        _psiLabel.text = @"Current data unavaliable";
    }
    
    [self updateLabels];
    
    if (_hour > 20 || _hour < 7) {
        // Set a night time background picture (this is only if we can't get webcam images before release)
    }
    NSLog(@"SWAG SWAG DATA %@", _results);
    Graph* graph = [[Graph alloc] initWithData:_results frame:CGRectMake(0, 0, 1280, 200) controller:self];
    // _graphView.backgroundColor = [UIColor clearColor];
    [_graphView addSubview:graph];
    _graphView.contentSize = CGSizeMake(1280, 312);
    
    if (fromRefresh) {
        [self redrawInterface];
    }
}

- (void)updateLabels
{
    _psiLabel.text = [NSString stringWithFormat:@"%@", [_results objectForKey:_hourString]];
    _time.text = [self getSingaporeTimeWithMinutes:YES];
    
    int psi = [_psiLabel.text intValue];
    
    
    if (psi < 51) {
        // 'Good'
        _health.text = @"Good";
        _health.textColor = [UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:1.0];
    }
    else if (psi < 101) {
        _health.text = @"Moderate";
        _health.textColor = [UIColor colorWithRed:0.953 green:0.612 blue:0.071 alpha:1.0];
    }
    else if (psi < 201) {
        _health.text = @"Unhealthy";
        _health.textColor = [UIColor colorWithRed:0.953 green:0.612 blue:0.071 alpha:1.0];
    }
    else if (psi < 300) {
        _health.text = @"Very unhealthy";
        _health.textColor = [UIColor colorWithRed:0.753 green:0.224 blue:0.169 alpha:1.0];
    }
    else if (psi >= 300){
        _health.text = @"Hazardous";
        _health.textColor = [UIColor colorWithRed:0.608 green:0.349 blue:0.714 alpha:1.0];
    }
    
    [self removeLoadingView];

}

- (void)removeLoadingView
{
    [UIView animateWithDuration:2.0 animations:^{
        _loadingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_loadingView removeFromSuperview];
    }];
}

- (NSString *)getSingaporeTimeWithMinutes:(BOOL)minutes
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (minutes) {
        dateFormatter.dateFormat = @"HH:mm";
    } else {
        dateFormatter.dateFormat = @"HH";
    }
    
    NSTimeZone *sgt = [NSTimeZone timeZoneWithAbbreviation:@"SGT"];
    [dateFormatter setTimeZone:sgt];
    
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    
    return time;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0) {
        CGPoint offset = scrollView.contentOffset;
        offset.y = 0;
        scrollView.contentOffset = offset;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

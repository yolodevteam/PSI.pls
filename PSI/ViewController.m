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
@synthesize errorLabel = _errorLabel;
@synthesize errorRefresh = _errorRefresh;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *date = [self getSingaporeTimeWithMinutes:NO];
    
    int hour = [date intValue];
    
    NSLog(@"Init viewDidLoad");
    //background swag

    
    if (hour > 19 || hour < 7) {
        // Set a night time background picture (this is only if we can't get webcam images before release)
        if (IS_4INCH_SCREEN) {
            self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"bg_iphone-568h.jpg"] imageWithGaussianBlur]];
        } else {
            self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"bg_iphone.jpg"] imageWithGaussianBlur]];
        }
    } else {
        if (IS_4INCH_SCREEN) {
            self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"bg_blue-568h.jpg"] imageWithGaussianBlur]];
        } else {
            self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"bg_blue.jpg"] imageWithGaussianBlur]];
        }
    }
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dawo.me/psi/all.json"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    _psiLabel.text = @"0";
    
    [_info addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
        
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height + 20)];
    _loadingView.backgroundColor = [UIColor blackColor];
    
    _act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _act.center = _loadingView.center;
    
    [_loadingView addSubview:_act];
    [_act startAnimating];
    
    _errorLabel = [[UILabel alloc] init];
    _errorLabel.alpha = 0.0;
    _errorLabel.frame = CGRectMake(0, 0, 320, 100);
    _errorLabel.center = _loadingView.center;
    _errorLabel.textColor = [UIColor whiteColor];
    _errorLabel.font = [UIFont fontWithName:@"Helvetica UltraLight" size:30];
    _errorLabel.backgroundColor = [UIColor clearColor];
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.textColor = [UIColor whiteColor];
    
    [_loadingView addSubview:_errorLabel];
    
    _errorRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    //_errorRefresh.frame = CGRectMake(((self.view.bounds.size.width / 2) - (0.5 * 15)), ((self.view.bounds.size.height / 2) - (0.5 * 19)), 15, 19);
    _errorRefresh.frame = CGRectMake(0, 0, 15, 19);
    [_errorRefresh setImage:[UIImage imageNamed:@"UIBarButtonRefresh.png"] forState:UIControlStateNormal];
    [_errorRefresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
    
    [_loadingView addSubview:_errorRefresh];
        
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
    _psiLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    _psiLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    _psiLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    _psiLabel.layer.shadowRadius = 6.0;
    _psiLabel.layer.shadowOpacity = 0.25;
    _psiLabel.layer.masksToBounds = NO;
    
    //region labels
    self.pm25Region.alpha = 0;
    self.pm25RegionLabel.alpha = 0;
    self.psiRegion.alpha = 0;
    self.psiRegionLabel.alpha = 0;
    
    //detail labels
    self.psiDetail.alpha = 0;
    self.psiDetailLabel.alpha = 0;
    self.pm25Detail.alpha = 0;
    self.pm25DetailLabel.alpha = 0;
    
    _health.layer.shadowColor = [[UIColor blackColor] CGColor];
    _health.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    _health.layer.shadowRadius = 2.0;
    _health.layer.shadowOpacity = 0.25;
    _health.layer.masksToBounds = NO;
    
    
    CALayer* layer = [_health layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2] CGColor];
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(-1, layer.frame.size.height-1, layer.frame.size.width, 1);
    [bottomBorder setBorderColor:[[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2] CGColor]];
    [layer addSublayer:bottomBorder];
    
}

- (void)refreshData
{
    _refresh.enabled = NO;

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dawo.me/psi/all.json"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // Animation block, fade all but time out lessen the blur while loading.
    _act.center = self.view.center;
    _act.alpha = 0.0;
    [_act startAnimating];
    [self.view addSubview:_act];
    
    [UIView animateWithDuration:1.0 animations:^{
        if (self.psiDetail.alpha == 1.0) {
            self.psiDetail.alpha = 0.0;
            self.psiRegion.alpha = 0.0;
            self.psiDetailLabel.alpha = 0.0;
            self.psiRegionLabel.alpha = 0.0;
            self.pm25Detail.alpha = 0.0;
            self.pm25DetailLabel.alpha = 0.0;
            self.pm25Region.alpha = 0.0;
            self.pm25RegionLabel.alpha = 0.0;
        }
        _psiLabel.alpha = 0.0;
        _health.alpha = 0.0;
        _graphView.alpha = 0.0;
        _act.alpha = 1.0;
        _refresh.alpha = 0.0;
        _pageControl.alpha = 0.0;
        _info.alpha = 0.0;
    } completion:^(BOOL finished) {
        redrawTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(redrawInterface) userInfo:nil repeats:YES];
        [redrawTimer fire];
    }];
}

- (void)redrawInterface
{
    if (canRedraw) {
        
        [redrawTimer invalidate];
        
        _refresh.enabled = YES;
    
        [UIView animateWithDuration:1.0 animations:^{
            _psiLabel.alpha = 1.0;
            _health.alpha = 1.0;
            _graphView.alpha = 1.0;
            _act.alpha = 0.0;
            _refresh.alpha = 1.0;
            _time.alpha = 1.0;
            _info.alpha = 1.0;
            _pageControl.alpha = 1.0;
        } completion:^(BOOL finished){
            [_act removeFromSuperview];
        }];
    }
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
    
    _errorLabel.text = @"Failed to load data.";
    
    [UIView animateWithDuration:1.0 animations:^{
        _act.alpha = 0.0;
        _errorLabel.alpha = 1.0;
    }completion:^(BOOL finished){
        [_act removeFromSuperview];
    }];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Data recieved");
    
    NSError *err;
    
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:&err];
    NSLog(@"%@", results);
    if (err) {
        NSLog(@"There was an error reading data: %@", err);
        
        _errorLabel.text = @"Failed to load data.";
        
        [UIView animateWithDuration:1.0 animations:^{
            _act.alpha = 0.0;
            _errorLabel.alpha = 1.0;
        }completion:^(BOOL finished){
            [_act removeFromSuperview];
        }];
        
        return;
    }
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
   
    NSString *date = [self getSingaporeTimeWithMinutes:NO];
    
    int hour = [date intValue];
    
    _hour = hour;
    _hourString = [NSString stringWithFormat:@"%d", _hour];
    if ([_hourString length] == 1) {
        _hourString = [NSString stringWithFormat:@"0%d", _hour];
    }
    
    PSIs = [NSMutableDictionary dictionaryWithCapacity:24];
    for (NSString *key in results) {
        NSArray* split = [key componentsSeparatedByString:@":"];
        
        if (([split[0] integerValue] == day) && ([split[1] integerValue] == month) && ([[NSString stringWithFormat:@"%@", split[2]] isEqual:_hourString])) {
            _results = [results objectForKey:key];
            
        }
        if ((_hour == 0) && ([split[2] integerValue] == 23)) {
            _results = [results objectForKey:key];
        }
        NSString* hourKey = split[2];
        if ([split[2] integerValue] < (hour+1)) {
            [PSIs setObject:[[[results objectForKey:key] objectForKey:@"psi"] objectForKey:@"3hr"] forKey:hourKey];
        }
        
    }
    if (!_results) {
        NSLog(@"hello polis");
        _hourString = [NSString stringWithFormat:@"%d", _hour-1];
        NSString* monthString = [NSString stringWithFormat:@"%d", month];
        NSString* dayString = [NSString stringWithFormat:@"%d", day];
        
        if ([_hourString length] == 1) {
            _hourString = [NSString stringWithFormat:@"0%d", _hour-1];
        }
        if ([dayString length] == 1) {
            dayString = [NSString stringWithFormat:@"0%d", day];
        }
        if ([monthString length] == 1) {
            monthString = [NSString stringWithFormat:@"0%d", month];
        }
        
        NSString* key = [NSString stringWithFormat:@"%@:%@:%@", dayString, monthString, _hourString];
        NSLog(@"key %@", key);
        _results = [results objectForKey:key];
        NSLog(@"results %@", _results);
    }
        
   /* if ([[NSString stringWithFormat:@"%@", [_results objectForKey:_hourString]] isEqual: @"0"]) {
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
    }*/
    
    [self updateLabels];
    
   [[_graphView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _graphView.pagingEnabled = TRUE;
    Graph* graph = [[Graph alloc] initWithData:PSIs frame:CGRectMake(0, 0, 1280, 312) controller:self];
    // _graphView.backgroundColor = [UIColor clearColor];
    [_graphView addSubview:graph];
 
    _graphView.contentSize = CGSizeMake(1280, 900);
    _graphView.delegate = self;
    _graphView.showsHorizontalScrollIndicator = NO;
    _graphView.showsVerticalScrollIndicator = NO;
    _graphView.scrollsToTop = NO;
    canRedraw = YES;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (sender.contentOffset.y > 0 || sender.contentOffset.y < 0) {
        CGPoint offset = sender.contentOffset;
        offset.y = 0;
        sender.contentOffset = offset;
    }
    CGFloat pageWidth = _graphView.frame.size.width;
    int page = floor((_graphView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)updateLabels
{
    //NSLog(@"results %@", _results);
    _psiLabel.text = [NSString stringWithFormat:@"%@", [[_results objectForKey:@"psi"] objectForKey:@"3hr"]];
    _time.text = [self getSingaporeTimeWithMinutes:YES];
    
    int psi = [_psiLabel.text intValue];
    float alpha = 0.35;
    
    if (psi < 51) {
        // 'Good'
        _health.text = @"Good";
        _health.layer.backgroundColor = [[UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:alpha] CGColor];
    }
    else if (psi < 101) {
        _health.text = @"Moderate";
        _health.layer.backgroundColor = [[UIColor colorWithRed:0.827 green:0.329 blue:0 alpha:alpha] CGColor];
    }
    else if (psi < 201) {
        _health.text = @"Unhealthy";
        _health.layer.backgroundColor = [[UIColor colorWithRed:0.953 green:0.612 blue:0.071 alpha:alpha] CGColor];
    }
    else if (psi < 300) {
        _health.text = @"Very unhealthy";
       _health.layer.backgroundColor = [[UIColor colorWithRed:0.753 green:0.224 blue:0.169 alpha:alpha] CGColor];
    }
    else if (psi >= 300){
        _health.text = @"Hazardous";
       _health.layer.backgroundColor = [[UIColor colorWithRed:0.608 green:0.349 blue:0.714 alpha:alpha] CGColor];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.view];
    
    NSLog(@"x: %f y: %f", point.x, point.y);
    
    if (point.x < 320 && point.y < 209) {
        // Touched the top some where, switch views.
        [UIView animateWithDuration:1.0 animations:^{
            if (self.psiDetail.alpha == 1.0) {
                self.psiDetail.alpha = 0.0;
                self.psiRegion.alpha = 0.0;
                self.psiDetailLabel.alpha = 0.0;
                self.psiRegionLabel.alpha = 0.0;
                self.pm25Detail.alpha = 0.0;
                self.pm25DetailLabel.alpha = 0.0;
                self.pm25Region.alpha = 0.0;
                self.pm25RegionLabel.alpha = 0.0;
                _psiLabel.alpha = 1.0;
                _health.alpha = 1.0;
                _refresh.alpha = 1.0;
                _time.alpha = 1.0;
            } else {
                self.psiDetail.alpha = 1.0;
                self.psiRegion.alpha = 1.0;
                self.psiDetailLabel.alpha = 1.0;
                self.psiRegionLabel.alpha = 1.0;
                self.pm25Detail.alpha = 1.0;
                self.pm25DetailLabel.alpha = 1.0;
                self.pm25Region.alpha = 1.0;
                self.pm25RegionLabel.alpha = 1.0;
                _psiLabel.alpha = 0.0;
                _health.alpha = 0.0;
                _time.alpha = 0.0;
            }

        } completion:^(BOOL finished) {
        }];

        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

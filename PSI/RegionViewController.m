//
//  RegionViewController.m
//  PSI
//
//  Created by Terence Tan on 3/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RegionViewController.h"


@interface RegionViewController ()

@end


@implementation RegionViewController

@synthesize pollutantData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)handleDoubleTap:(UIGestureRecognizer*)gr {
    NSLog(@"================= double tap ============");
    self.infoView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //self.infoView.delegate = self;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.infoView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.mainView presentViewController:self.infoView animated:YES completion:nil];
    
}

- (void)handleTap:(UIGestureRecognizer*)gr {
    NSLog(@"----------------- tap ----------------");
}
- (void)viewDidLoad
{
    _pm25Value.adjustsFontSizeToFitWidth = YES;
    
    [self addShadow:_psiValue];
    [self addShadow:_pm25Value];

    [super viewDidLoad];
    UITapGestureRecognizer *dtr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    dtr.numberOfTapsRequired = 2;
    
    UIGestureRecognizer *tr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    [tr requireGestureRecognizerToFail:dtr];
    [_pm25Value addGestureRecognizer:tr];
    [_pm25Value addGestureRecognizer:dtr];
    self.infoView = [[HealthInfoViewController alloc] initWithNibName:@"HealthInfoViewController" bundle:nil];

    
    // Do any additional setup after loading the view from its nib.
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [touches anyObject];
    if (touch.view.tag != 0) {
        NSLog(@"touch tag: %ld", (long)touch.view.tag);
        [self changeSubreading:touch.view.tag];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeSubreading:(int) i {
    NSString* html;
    NSString* key;
    UILabel* label;
    switch (i) {
        case 1:
            label = _pm25Label;
            html = @"pm25.html";
            key = @"PM2.5";
            break;
        case 2:
            label = _pm10Label;
            html= @"pm10.html";
            key = @"PM10";
            break;
        case 3:
            label = _no3Label;
            html = @"no2.html";
            key = @"NO2";
            break;
        case 4:
            label = _ozoneLabel;
            html = @"ozone.html";
            key = @"O3";
            break;
        case 5:
            label = _so2Label;
            html = @"so2.html";
            key = @"SO2";
            break;
        case 6:
            label = _coLabel;
            html = @"co.html";
            key = @"CO";
            break;
    }
    double alpha = 0.5;
    [UIView animateWithDuration:0.3
                     animations:^{
                        
                         _pm25Label.alpha = alpha;
                         _pm10Label.alpha = alpha;
                         _coLabel.alpha = alpha;
                         _ozoneLabel.alpha = alpha;
                         _no3Label.alpha = alpha;
                         _so2Label.alpha = alpha;
                         label.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                     }];
   
    NSLog(@"pollutant data array %@", [[self getPollutantData] getLastHourData]);
    NSDictionary* dict = [self getLastDictionary];
    NSLog(@"swag swag swag %@", [dict objectForKey:key]);
    _pm25Value.text = strip_brackets([dict objectForKey:key]);
    int AQI = getAQIfromPM25([_pm25Value.text floatValue]);
    _pm25Health.text = getHealthFromAQI(AQI);
    
    
}

NSString* strip_brackets(NSString* string) {
    NSCharacterSet *remove = [NSCharacterSet characterSetWithCharactersInString:@"()"];
    NSString* s = [[string componentsSeparatedByCharactersInSet: remove] componentsJoinedByString: @" "];
    return [s componentsSeparatedByString:@" "][0];
}


double strip_brackets_double(NSString* string) {
    NSString* d = strip_brackets(string);
    return [d doubleValue];
}
-(NSDictionary*)getLastDictionary {
    NSLog(@"pollutant data array %@", [[self getPollutantData] getLastHourData]);
    for (NSDictionary* dict in [[self getPollutantData] getLastHourData]) {
        if ([[[dict objectForKey:@"Region"] lowercaseString] isEqualToString:self.region]) {
            NSLog(@"dict %@", dict);
            regionDictionary = dict;
            return dict;
        }
    }
    return NULL;
}

-(void) setPollutantData:(PollutantData *)data {
    [super setPollutantData:data];
    if ([self.region isEqualToString:@"3hr"]) {
        return;
    }
    self.psiValue.text = strip_brackets([[self getLastDictionary] objectForKey:@"PM10"]);
   
    int pm10 = [[[self getLastDictionary] objectForKey:@"PM10"] integerValue];
    self.psiHealth.text = getHealthFromPSI(pm10);
    self.psiHealth.backgroundColor = getColorFromPSI(pm10, 0.7);
    
    //compute average
    NSLog(@"computing average");
    double pm10avg = 0.0, pm25avg = 0.0, no2avg = 0.0, o3avg = 0.0, so2avg = 0.0, coavg = 0.0;
    for (NSArray* hour in data.sortedResults) {
        for (NSDictionary* dict in hour) {
            if ([[[dict objectForKey:@"Region"] lowercaseString] isEqualToString:self.region]) {
                NSLog(@"AVERAGEEGGGGGGGGGG");
                pm10avg += strip_brackets_double([dict objectForKey:@"PM10"]);
                pm25avg += strip_brackets_double([dict objectForKey:@"PM25"]);
                no2avg += strip_brackets_double([dict objectForKey:@"NO2"]);
                so2avg += strip_brackets_double([dict objectForKey:@"SO2"]);
                coavg += strip_brackets_double([dict objectForKey:@"CO"]);
                o3avg += strip_brackets_double([dict objectForKey:@"O3"]);
                NSLog(@"pm10avg %f", pm10avg);
            }
        }
    }
    

}

-(void)setData:(PSIData *)data {
    [super setData:data];
    int psiValue = [[data getLastHourData] integerValue];
    self.psiHealth.backgroundColor = getColorFromPSI(psiValue, 0.7);
    self.psiValue.text = [NSString stringWithFormat:@"%d", psiValue];
    self.psiHealth.text = getHealthFromPSI(psiValue);
    
    
    //int pm25;
    /*if ([_region isEqualToString:@"3hr"]) {
        int pm25high = [[[[data getLastHourData] objectForKey:@"pm25"] objectForKey:@"max"] integerValue];
        int pm25low = [[[[data getLastHourData] objectForKey:@"pm25"] objectForKey:@"min"] integerValue];
        pm25 = ceil((pm25high + pm25low)/2);
        self.pm25Value.text = [NSString stringWithFormat:@" %d - %d ", pm25low, pm25high];

    }
    else {
        pm25 = [[[[data getLastHourData] objectForKey:@"pm25"] objectForKey:_region] integerValue];
        self.pm25Value.text = [NSString stringWithFormat:@"%d", pm25];
    }*/
    /*int AQI = [data getAQIfromPM25:pm25];
    self.pm25Health.backgroundColor = [data getColorFromAQI:AQI];
    self.pm25Health.text = [data getHealthFromAQI:AQI];*/

}

- (void) addShadow:(UILabel* )label {
    label.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    label.layer.shadowRadius = 3.0;
    label.layer.shadowOpacity = 0.35;
    label.layer.masksToBounds = NO;
}

@end

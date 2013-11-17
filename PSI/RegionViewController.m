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

double pm10avg = 0.0, pm25avg = 0.0, no2avg = 0.0, o3avg = 0.0, so2avg = 0.0, coavg = 0.0;
double pm10_t, pm10_l, pm25_t, pm25_l, no2_t, no2_l, o3_t, o3_l, so2_t, so2_l, co_t, co_l;

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
    self.infoView.key = key;
    [self.mainView presentViewController:self.infoView animated:YES completion:nil];
    [self.infoView openHTML];
    [self.infoView setTitle:name];
    
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

   
    UILabel* label;
    NSString* range, *unit;
    double avg = 0;
    switch (i) {
        case 1:
            label = _pm25Label;
            key = @"PM2.5";
            range = [NSString stringWithFormat:@"%d - %d", (int)pm25_l, (int)pm25_t];
            avg = (pm25_t + pm25_l)/2;
            unit = @"µg/m3";
            name = @"PM2.5";
            break;
        case 2:
            label = _pm10Label;
            key = @"PM10";
            range = [NSString stringWithFormat:@"%d - %d", (int)pm10_l, (int)pm10_t];
            avg = (pm25_t + pm25_l)/2;
            name = @"PM10";
            unit = @"µg/m3";
            break;
        case 3:
            label = _no3Label;
            key = @"NO2";
            range = [NSString stringWithFormat:@"%d - %d", (int)no2_l, (int)no2_t];
            avg = (no2_t + no2_l)/2;
            name = @"Nitrogen Dioxide";
            unit = @"µg/m3";
            break;
        case 4:
            label = _ozoneLabel;
            key = @"O3";
            range = [NSString stringWithFormat:@"%d - %d", (int)o3_l, (int)o3_t];
            avg = (o3_t + o3_l)/2;
            name = @"Ozone";
            unit = @"µg/m3";
            break;
        case 5:
            label = _so2Label;
            key = @"SO2";
            range = [NSString stringWithFormat:@"%d - %d", (int)so2_l, (int)so2_t];
            avg = (so2_t + so2_l)/2;
            name = @"Sulfur dioxide";
            unit = @"µg/m3";
            break;
        case 6:
            label = _coLabel;
            key = @"CO";
            range = [NSString stringWithFormat:@"%.01f - %.01f", co_l, co_t];
            avg = (co_t + co_l)/2;
            name = @"Carbon monoxide";
            unit = @"mg/m3";
            break;
    }
    NSLog(@"range %@", range);
    double alpha = 0.5;
    _unitLabel.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         _pm25Label.alpha = alpha;
                         _pm10Label.alpha = alpha;
                         _coLabel.alpha = alpha;
                         _ozoneLabel.alpha = alpha;
                         _no3Label.alpha = alpha;
                         _so2Label.alpha = alpha;
                         _pm25Value.alpha = 0;
                         _pm25Health.alpha = 0;
                         label.alpha = 1;
                         _unitLabel.text = unit;
                         _unitLabel.alpha = 1;
                     } completion:^(BOOL finished) {
                     }];
   
    NSLog(@"pollutant data array %@", [[self getPollutantData] getLastHourData]);
    NSDictionary* dict = [self getLastDictionary];
    NSLog(@"swag swag swag %@", [dict objectForKey:key]);
    int AQI;
    if ([self.region isEqualToString:@"3hr"]) {
        _pm25Value.text = range;
        AQI = getAQIfromPM25(avg);
    }
    else {
        _pm25Value.text = strip_brackets([dict objectForKey:key]);
        AQI = getAQIfromPM25([_pm25Value.text floatValue]);
    }
    _pm25Health.text = getHealthFromAQI(AQI);
    _pm25Health.backgroundColor = getColorFromAQI(AQI);
    [UIView animateWithDuration:0.5
                     animations:^{
                         _pm25Value.alpha = 1;
                         _pm25Health.alpha = 1;
                     }];
    
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
        for (NSArray* hour in data.sortedResults) {
            for (NSDictionary* dict in hour) {
                //CO
                if (co_l == 0) {
                    co_l = strip_brackets_double([dict objectForKey:@"CO"]);
                    no2_l = strip_brackets_double([dict objectForKey:@"NO2"]);
                    o3_l = strip_brackets_double([dict objectForKey:@"O3"]);
                    pm10_l = strip_brackets_double([dict objectForKey:@"PM10"]);
                    pm25_l = strip_brackets_double([dict objectForKey:@"NO2"]);
                    so2_l = strip_brackets_double([dict objectForKey:@"SO2"]);
                    
                }
                if (strip_brackets_double([dict objectForKey:@"CO"]) > co_t) {
                    co_t = strip_brackets_double([dict objectForKey:@"CO"]);
                }
                else if (strip_brackets_double([dict objectForKey:@"CO"]) < co_l) {
                    co_l = strip_brackets_double([dict objectForKey:@"CO"]);
                }
                
                //NO2
                
                else if (strip_brackets_double([dict objectForKey:@"NO2"]) > no2_t) {
                    no2_t = strip_brackets_double([dict objectForKey:@"NO2"]);
                }
                else if (strip_brackets_double([dict objectForKey:@"NO2"]) < no2_l) {
                    no2_l = strip_brackets_double([dict objectForKey:@"NO2"]);
                }
                
                //O3
                
                else if (strip_brackets_double([dict objectForKey:@"O3"]) > o3_t) {
                    o3_t = strip_brackets_double([dict objectForKey:@"O3"]);
                }
                else if (strip_brackets_double([dict objectForKey:@"O3"]) < o3_l) {
                    o3_l = strip_brackets_double([dict objectForKey:@"O3"]);
                }
                
                //PM10
                else if (strip_brackets_double([dict objectForKey:@"PM10"]) > pm10_t) {
                    pm10_t = strip_brackets_double([dict objectForKey:@"PM10"]);
                }
                else if (strip_brackets_double([dict objectForKey:@"PM10"]) < pm10_l) {
                    pm10_l = strip_brackets_double([dict objectForKey:@"PM10"]);
                }
                
                //PM25
                else if (strip_brackets_double([dict objectForKey:@"PM2.5"]) > pm25_t) {
                    pm25_t = strip_brackets_double([dict objectForKey:@"NO2"]);
                }
                else if (strip_brackets_double([dict objectForKey:@"PM2.5"]) < pm25_l) {
                    pm25_l = strip_brackets_double([dict objectForKey:@"NO2"]);
                }
                
                
                //SO2
                else if (strip_brackets_double([dict objectForKey:@"NO2"]) > so2_t) {
                    so2_t = strip_brackets_double([dict objectForKey:@"SO2"]);
                }
                else if (strip_brackets_double([dict objectForKey:@"NO2"]) < so2_l) {
                    so2_l = strip_brackets_double([dict objectForKey:@"SO2"]);
                }
            }
        }
        [self changeSubreading:1];
        return;
    }
    self.psiValue.text = strip_brackets([[self getLastDictionary] objectForKey:@"PM10"]);
    NSLog(@"%@", [[self getLastDictionary] objectForKey:@"PM10"]);
    int pm10 = strip_brackets_double([[self getLastDictionary] objectForKey:@"PM10"]);
    self.psiHealth.text = getHealthFromPSI(pm10);
    self.psiHealth.backgroundColor = getColorFromPSI(pm10, 0.7);
    
    //compute average
    NSLog(@"computing average");
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
    pm10avg = pm10avg/24;
    pm25avg = pm25avg/24;
    no2avg = no2avg/24;
    so2avg = so2avg/24;
    coavg = coavg/24;
    o3avg = o3avg/24;
    
    NSNumber *pm10_d, *pm25_d, *no2_d, *so2_d, *co_d, *o3_d;
    NSDictionary* dict = [self getLastDictionary];
    
    pm10_d = [NSNumber numberWithDouble:strip_brackets_double([dict objectForKey:@"PM10"]) - pm10avg ];
    pm25_d = [NSNumber numberWithDouble:strip_brackets_double([dict objectForKey:@"PM25"]) - pm25avg ];
    no2_d = [NSNumber numberWithDouble:strip_brackets_double([dict objectForKey:@"NO2"]) - no2avg ];
    so2_d = [NSNumber numberWithDouble:strip_brackets_double([dict objectForKey:@"SO2"]) - so2avg ];
    co_d = [NSNumber numberWithDouble:strip_brackets_double([dict objectForKey:@"CO"]) - coavg ];
    o3_d = [NSNumber numberWithDouble:strip_brackets_double([dict objectForKey:@"O3"]) - o3avg ];
    
    NSArray* unsorted = [[NSArray alloc] initWithObjects:pm10_d, pm25_d, no2_d, so2_d, co_d, o3_d, nil];
    NSArray* sortedNumbers = [unsorted sortedArrayUsingSelector:@selector(intValue)];
    if ([sortedNumbers lastObject] == pm10_d) {
        [self changeSubreading:2];
    }
    else if ([sortedNumbers lastObject] == pm25_d) {
        [self changeSubreading:1];
    }
    else if ([sortedNumbers lastObject] == no2_d) {
        [self changeSubreading:3];
    }
    else if ([sortedNumbers lastObject] == so2_d) {
        [self changeSubreading:5];
    }
    else if ([sortedNumbers lastObject] == co_d) {
        [self changeSubreading:6];
    }
    else if ([sortedNumbers lastObject] == o3_d) {
        [self changeSubreading:4];
    }
    else {
        [self changeSubreading:1];
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

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    _pm25Value.adjustsFontSizeToFitWidth = YES;
    [self addShadow:_psiValue];
    [self addShadow:_pm25Value];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setData:(PSIData *)data {
    int psiValue = [[[[data getLastHourData] objectForKey:@"psi"] objectForKey:_region] integerValue];
    self.psiHealth.backgroundColor = [data getColorFromPSI:psiValue withAlpha:0.7];
    self.psiValue.text = [NSString stringWithFormat:@"%d", psiValue];
    self.psiHealth.text = [data getHealthFromPSI:psiValue];
    int pm25;
    if ([_region isEqualToString:@"3hr"]) {
        int pm25high = [[[[data getLastHourData] objectForKey:@"pm25"] objectForKey:@"max"] integerValue];
        int pm25low = [[[[data getLastHourData] objectForKey:@"pm25"] objectForKey:@"min"] integerValue];
        pm25 = ceil((pm25high + pm25low)/2);
        self.pm25Value.text = [NSString stringWithFormat:@" %d - %d ", pm25low, pm25high];

    }
    else {
        pm25 = [[[[data getLastHourData] objectForKey:@"pm25"] objectForKey:_region] integerValue];
        self.pm25Value.text = [NSString stringWithFormat:@"%d", pm25];
    }
    int AQI = [data getAQIfromPM25:pm25];
    self.pm25Health.backgroundColor = [data getColorFromAQI:AQI];
    self.pm25Health.text = [data getHealthFromAQI:AQI];

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

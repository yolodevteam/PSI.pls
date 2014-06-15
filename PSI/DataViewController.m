//
//  DataViewController.m
//  PSI
//
//  Created by Terence Tan on 3/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController {

}

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setData:(PSIData* )data {
    _data = data;
}
/*-(void)setPollutantData:(PollutantData *)data {
    _pollutantData = data;
}
-(PollutantData*) getPollutantData {
    return _pollutantData;
}*/


@end

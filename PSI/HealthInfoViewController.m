//
//  HealthInfoViewController.m
//  PSI
//
//  Created by Terence Tan on 16/11/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "HealthInfoViewController.h"

@interface HealthInfoViewController ()

@end

@implementation HealthInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
-(IBAction) done:(id) sender {
    NSLog(@"save");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

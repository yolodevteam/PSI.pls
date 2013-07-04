//
//  MainViewController.m
//  PSI
//
//  Created by Terence Tan on 1/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "MainViewController.h"
#import "UIImage+Tools.m"
#import "InformationViewController.h"
#import "PSIData.h"
#import "DataViewController.h"
#import "RegionViewController.h"

@interface MainViewController ()


@end

@implementation MainViewController



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
    NSLog(@"hello swag");
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = self.pagesView.bounds;
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.pagesView addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];

    RegionViewController *historyController = [[RegionViewController alloc] initWithNibName:@"RegionViewController" bundle:nil];
    historyController.title = @"History";

    RegionViewController *threeHourController = [[RegionViewController alloc] initWithNibName:@"RegionViewController" bundle:nil];
    threeHourController.title = @"3-Hour";
    threeHourController.region = @"3hr";


    RegionViewController *northController = [[RegionViewController alloc] initWithNibName:@"RegionViewController" bundle:nil];
    northController.title = @"North";
    northController.region = @"north";

    RegionViewController *southController = [[RegionViewController alloc] initWithNibName:@"RegionViewController" bundle:nil];
    southController.title = @"South";
    southController.region = @"south";

    RegionViewController *eastController = [[RegionViewController alloc] initWithNibName:@"RegionViewController" bundle:nil];
    eastController.title = @"East";
    eastController.region = @"east";

    RegionViewController *westController = [[RegionViewController alloc] initWithNibName:@"RegionViewController" bundle:nil];
    westController.title = @"West";
    westController.region = @"west";

    RegionViewController *centralController = [[RegionViewController alloc] initWithNibName:@"RegionViewController" bundle:nil];
    centralController.title = @"Central";
    centralController.region = @"central";




    self.pagesContainer.viewControllers = @[historyController, threeHourController, northController, southController, eastController, westController, centralController];
    // Do any additional setup after loading the view from its nib.
    
        
    [self.info addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    
   /* _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height + 20)];
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
    _errorRefresh.frame = CGRectMake(0, 0, 15, 19);
    [_errorRefresh setImage:[UIImage imageNamed:@"UIBarButtonRefresh.png"] forState:UIControlStateNormal];
    [_errorRefresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
    
    [_loadingView addSubview:_errorRefresh];
    
    [self.view addSubview:_loadingView];
    */



}

- (void)showInfo
{
        InformationViewController *info = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
    info.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentModalViewController:info animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

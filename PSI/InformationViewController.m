//
//  InformationViewController.m
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "InformationViewController.h"
#import "UIImage+Tools.h"
#import <QuartzCore/QuartzCore.h>

@interface InformationViewController ()

@end

@implementation InformationViewController

@synthesize done = _done;
@synthesize textView = _textView;

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
    // Do any additional setup after loading the view from its nib.
    
    [_done addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    
    _textView.text = @"Credits:\nNinjaLikesCheez: App development\nzhongfu: Backend development \nttwj: App and Backend development\n \nUsing data found at http://dawo.me/\n\nA YoloDev Team Production.\nImages (c) Colin Chan Photography 2013";
}

- (void)dismissSelf
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

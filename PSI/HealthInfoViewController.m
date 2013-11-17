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
    [self openHTML];
    
}
-(IBAction) done:(id) sender {
    NSLog(@"save");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void) setTitle:(NSString *)title {
    NSLog(@"title bro %@", title);
    self.bar.topItem.title = title;
}

-(void) openHTML {
    NSLog(@"self.key %@", self.key);
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:self.key ofType:@"html"];
    NSLog(@"html file %@", htmlFile);
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"html string %@", htmlString);
    [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

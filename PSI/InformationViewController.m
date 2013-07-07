//
//  InformationViewController.m
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "InformationViewController.h"
#import "RTLabel.h"

@interface InformationViewController ()

@end

@implementation InformationViewController

@synthesize done = _done;
//@synthesize textView = _textView;

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
    static NSString *sample_text = @"<font color='#ffffff'><font face='HelveticaNeue-CondensedBold' size=20>Credits</font><p>Thomas Hedderwick - App Development</p><p>Terence Tan - App/Backend development</p><p>Li Zhongfu - Backend development</p></font>"
            "<p face='HelveticaNeue-CondensedBold' size=18 color='#ccc'>Legal</p>";

    RTLabel *label = [[RTLabel alloc] initWithFrame:self.view.frame];
    [self.labelView addSubview:label];
    [label setText:sample_text];
    NSString *pathToFile = [[NSBundle mainBundle] pathForResource:@"legal" ofType:@"txt"];
    NSString *theText = [NSString stringWithContentsOfFile:pathToFile encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"the text %@", theText);
    self.textView.text = theText;
    //_textView.text = @"Credits:\nNinjaLikesCheez: App development\nzhongfu: Backend development \nttwj: App and Backend development\n \nUsing data found at http://dawo.me/\n\nA YoloDev Team Production.\nImages (c) Colin Chan Photography 2013";
}



- (void)dismissSelf
{
    //[self dismissModalViewControllerAnimated:YES];
    [self.delegate closeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

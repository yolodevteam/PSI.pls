//
//  HealthInfoViewController.h
//  PSI
//
//  Created by Terence Tan on 16/11/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HealthInfoViewController : UIViewController

-(void)setURL: (NSString*) url;
-(void)setTitle: (NSString*) title;
-(void) openHTML;

@property (nonatomic, strong) IBOutlet UIWebView* webView;
@property (nonatomic, strong) NSString* key;
@property (nonatomic, strong) IBOutlet UINavigationBar* bar;


@end

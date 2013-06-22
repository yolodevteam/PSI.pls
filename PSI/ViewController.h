//
//  ViewController.h
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSDictionary *results;
@property int hour;
@property (nonatomic, strong) IBOutlet UILabel *psiLabel;
@property (nonatomic, strong) NSString *hourString;
@property (nonatomic, strong) NSMutableData *responseData;

@end

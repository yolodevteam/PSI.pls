//
//  InformationViewController.h
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InformationViewControllerDelegate

-(void)closeView;

@end

@interface InformationViewController : UIViewController

@property (nonatomic, strong) id<InformationViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIButton *done;
@property (nonatomic, strong) IBOutlet UIView* labelView;
@property (nonatomic, strong) IBOutlet UITextView* textView;

@end

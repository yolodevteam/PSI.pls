//
//  PSIView.h
//  PSI
//
//  Created by Terence Tan on 24/6/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSIView : UIView
@property (nonatomic, strong) IBOutlet UILabel *psiLabel;
@property (nonatomic, strong) IBOutlet UILabel *health;
- (id)initWithFrame:(CGRect)frame;
@end

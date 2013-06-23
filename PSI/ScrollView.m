//
//  ScrollView.m
//  PSI
//
//  Created by Terence Tan on 23/6/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    NSLog(@"scrolled");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

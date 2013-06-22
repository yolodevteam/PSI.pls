//
//  PSI.m
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import "PSI.h"

@implementation PSI

@synthesize psi = _psi;
@synthesize time = _time;
@synthesize health = _health;

- (id)initWithPollutionIndex:(int)index hour:(NSInteger *)hour
{
    if (self = [super init]) {
        _psi = index;
        _time = hour;
        _health = [self calculateHealth];
    }
    
    return self;
}

- (NSString *)calculateHealth
{
    if (_psi > 50) {
        // 'Good'
        _health = @"Good";
    }
}

@end

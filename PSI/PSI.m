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
@synthesize healthColor = _color;
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
    if (_psi < 51) {
        // 'Good'
        _health = @"Good";
        _color = [UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:1.0];
    }
    else if (_psi < 101) {
        _health = @"Moderate";
        _color = [UIColor colorWithRed:0.953 green:0.612 blue:0.071 alpha:1.0];
    }
    else if (_psi < 201) {
        _health = @"Unhealthy";
        _color = [UIColor colorWithRed:0.953 green:0.612 blue:0.071 alpha:1.0];
    }
    else if (_psi < 301) {
        _health = @"Very unhealthy";
        _color = [UIColor colorWithRed:0.753 green:0.224 blue:0.169 alpha:1.0];
        
    }
    else {
        _health = @"Hazardous";
        _color = [UIColor colorWithRed:0.608 green:0.349 blue:0.714 alpha:1.0];
    }
    
}

@end

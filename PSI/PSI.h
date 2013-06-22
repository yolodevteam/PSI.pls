//
//  PSI.h
//  PSI
//
//  Created by Ninja on 22/06/2013.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSI : NSObject
{
    int psi;
    NSInteger *time;
    NSString *health;
    UIColor *healthColor;
}

@property int psi;
@property NSInteger *time;
@property NSString *health;
@property UIColor *healthColor;

@end

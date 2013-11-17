//
//  PSIData.h
//  PSI
//
//  Created by Terence Tan on 3/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PollutantData;
@protocol PollutantDataDelegate

-(void)loadingPollutantsCompleted:(PollutantData*) data;

@end

@interface PollutantData : NSObject<NSURLConnectionDataDelegate> {
    
}

@property (nonatomic, assign) id <PollutantDataDelegate> delegate;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSDictionary *results;
@property (nonatomic, strong) NSArray* sortedResults;
@property (nonatomic, strong) NSArray* sortedKeys;

-(void)loadData;
-(NSArray *) getLastHourData;
-(int) getLastHour;


@end
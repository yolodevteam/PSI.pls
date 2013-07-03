//
//  PSIData.h
//  PSI
//
//  Created by Terence Tan on 3/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PSIData;
@protocol PSIDataDelegate

-(void)loadingCompleted:(PSIData*) data;

@end

@interface PSIData : NSObject<NSURLConnectionDataDelegate> {
    NSArray* sortedKeys;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSDictionary *results;
@property (nonatomic, strong) NSArray* sortedResults;

-(void)loadData;

@end

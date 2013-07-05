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

}

@property (nonatomic, assign) id <PSIDataDelegate> delegate;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSDictionary *results;
@property (nonatomic, strong) NSArray* sortedResults;
@property (nonatomic, strong) NSArray* sortedKeys;

-(void)loadData;
-(NSDictionary *) getLastHourData;
-(int) getLastHour;

//utils
-(UIColor*) getColorFromPSI:(int) PSI withAlpha:(float) alpha;
- (NSString* )getHealthFromPSI:(int) PSI;
-(int)getAQIfromPM25: (float) PM25;
- (UIColor*) getColorFromAQI: (int) AQI;
- (NSString* )getHealthFromAQI:(int)AQI;

@end

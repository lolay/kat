//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Lolay)

- (NSInteger) ageForCalendar:(NSCalendar*) calendar;
- (NSInteger) age;
+ (NSInteger) ageFromDate:(NSDate*) date;
+ (NSInteger) ageFromDate:(NSDate*) date calendar:(NSCalendar*) calendar;

- (NSString*) rfc1123String;
+ (NSString*) rfc1123StringFromDate:(NSDate*) date;

- (BOOL) isEarlierThan:(NSDate*) date;
- (BOOL) isLaterThan:(NSDate*) date;

+ (NSDate*) midnightFromNow;
+ (NSDate*) midnightFromDate:(NSDate*) date;
- (NSDate*) midnight;

@end

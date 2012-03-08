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
- (NSString*) rfc1123StringForLocale:(NSLocale*) locale;
+ (NSString*) rfc1123StringFromDate:(NSDate*) date;
+ (NSString*) rfc1123StringFromDate:(NSDate *)date locale:(NSLocale*) locale;

- (BOOL) isEarlierThan:(NSDate*) date;
- (BOOL) isLaterThan:(NSDate*) date;

+ (NSDate*) midnight;
+ (NSDate*) midnightForDate:(NSDate*) date;
- (NSDate*) midnight;

@end

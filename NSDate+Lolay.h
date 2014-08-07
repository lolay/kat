//
//  Copyright 2012 Lolay, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>

@interface NSDate (Lolay)

- (NSInteger) ageForCalendar:(NSCalendar*) calendar;
- (NSInteger) age;
+ (NSInteger) ageFromDate:(NSDate*) date;
+ (NSInteger) ageFromDate:(NSDate*) date calendar:(NSCalendar*) calendar;

- (NSString*) rfc1123String;
+ (NSString*) rfc1123StringFromDate:(NSDate*) date;

- (NSString*) iso8601BasicString;
+ (NSString*) iso8601BasicStringFromDate:(NSDate*) date;

+ (NSDate *) dateFromISO8601String: (NSString *)anISO8601String;
+ (NSDate *) dateFromISO8601TruncatedString:(NSString *)anISO8601String;

- (NSString*) iso8601ExtendedString;
+ (NSString*) iso8601ExtendedStringFromDate:(NSDate*) date;

- (BOOL) isEarlierThan:(NSDate*) date;
- (BOOL) isLaterThan:(NSDate*) date;

+ (NSDate*) midnight;
+ (NSDate*) midnightForDate:(NSDate*) date;
- (NSDate*) midnight;

- (NSInteger)daysBetween:(NSDate *)compareDate;

@end

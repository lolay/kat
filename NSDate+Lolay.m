//
//  Copyright 2012 Lolay, Inc. All rights reserved.
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

#import "NSDate+Lolay.h"

@implementation NSDate (Lolay)

- (NSInteger) ageForCalendar:(NSCalendar*) calendar {
	if (self == nil) {
		return 0;
	}
	
	NSUInteger componentsFlag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents* componentsNow = [calendar components:componentsFlag fromDate:[NSDate date]];
	NSDateComponents* compnentsThen = [calendar components:componentsFlag fromDate:self];
	
	if (([componentsNow month] < [compnentsThen month]) || (([componentsNow month] == [compnentsThen month]) && ([componentsNow day] < [compnentsThen day]))) {
		return [componentsNow year] - [compnentsThen year] - 1;
	} else {
		return [componentsNow year] - [compnentsThen year];
	}
}

- (NSInteger) age {
	return [self ageForCalendar:[NSCalendar currentCalendar]];
}

+ (NSInteger) ageFromDate:(NSDate*) date calendar:(NSCalendar*) calendar {
	return [date ageForCalendar:calendar];
}

+ (NSInteger) ageFromDate:(NSDate*) date {
	return [date age];
}

- (NSString*) rfc1123StringForLocale:(NSLocale*) locale {
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss 'GMT'";
    formatter.locale = locale;
	NSString* dateValue = [formatter stringFromDate:self];
	return dateValue;
}

- (NSString*) rfc1123String {
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss 'GMT'";
	NSString* dateValue = [formatter stringFromDate:self];
	return dateValue;
}

+ (NSString*) rfc1123StringFromDate:(NSDate*) date {
	return [date rfc1123String];
}

+ (NSString*) rfc1123StringFromDate:(NSDate *)date locale:(NSLocale*) locale {
    return [date rfc1123StringForLocale:locale];
}

- (BOOL) isEarlierThan:(NSDate*) date {
	NSComparisonResult result = [self compare:date];
	return result == NSOrderedAscending;
}

- (BOOL) isLaterThan:(NSDate*) date {
	NSComparisonResult result = [self compare:date];
	return result == NSOrderedDescending;
}

+ (NSDate*) midnight {
	return [NSDate midnightForDate:[NSDate date]];
}

+ (NSDate*) midnightForDate:(NSDate*) date {
	return [date midnight];
}

- (NSDate*) midnight {
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components = [calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
	NSDate* midnight = [calendar dateFromComponents:components];
	return midnight;
}

@end

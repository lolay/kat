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

- (NSString*) iso8601ExtendedString {
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
	NSString* dateValue = [formatter stringFromDate:self];
	return dateValue;
}

+ (NSString*) iso8601ExtendedStringFromDate:(NSDate*) date {
	return [date iso8601ExtendedString];
}

- (NSString*) iso8601BasicString {
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	formatter.dateFormat = @"yyyyMMdd'T'HHmmss'Z'";
	NSString* dateValue = [formatter stringFromDate:self];
	return dateValue;
}

+ (NSString*) iso8601BasicStringFromDate:(NSDate*) date {
	return [date iso8601BasicString];
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

- (NSInteger)daysBetween:(NSDate *)compareDate {
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:self toDate:compareDate options:0];
    return [components day]+1;
}

@end

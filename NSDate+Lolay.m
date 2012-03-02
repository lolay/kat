//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
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

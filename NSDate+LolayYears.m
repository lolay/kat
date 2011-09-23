//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import "NSDate+LolayYears.h"

@implementation NSDate (LolayYears)

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

@end

//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import "NSDate+LolayRFC1123.h"

@implementation NSDate (LolayRFC1123)

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

@end

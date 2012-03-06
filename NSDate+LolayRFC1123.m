//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import "NSDate+LolayRFC1123.h"

@implementation NSDate (LolayRFC1123)

- (NSString*) rfc1123String {
    return [self rfc1123StringWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
}

- (NSString*) rfc1123StringWithLocale:(NSLocale*) locale {
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss 'GMT'";
    formatter.locale = locale;
	NSString* dateValue = [formatter stringFromDate:self];
	return dateValue;
}

+ (NSString*) rfc1123StringFromDate:(NSDate*) date {
	return [date rfc1123String];
}

+ (NSString*) rfc1123StringFromDate:(NSDate*) date locale:(NSLocale*) locale {
    return [date rfc1123StringWithLocale:locale];
}

@end

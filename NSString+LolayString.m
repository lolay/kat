//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import "NSString+LolayString.h"

@implementation NSString (LolayString)

+ (NSString*) stringWithInteger:(NSInteger) integerValue {
	return [NSString stringWithFormat:@"%i", integerValue];
}

+ (NSString*) stringCsvWithArray:(NSArray*) array {
	NSMutableString* string = [NSMutableString stringWithCapacity:32 * array.count];
	BOOL first = YES;
	for (NSObject* object in array) {
		if (first) {
			first = NO;
		} else {
			[string appendString:@","];
		}
		
		[string appendString:[object description]];
	}
	return string;
}

+ (NSString*) stringWithBOOL:(BOOL) boolValue {
	return boolValue ? @"YES" : @"NO";
}

- (NSString*) trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end

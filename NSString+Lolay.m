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

#import "NSString+Lolay.h"

@implementation NSString (Lolay)

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

+ (NSString*) stringWithUIImage:(UIImage*) image {
	return NSStringFromCGSize(image.size);
}

- (NSString*) trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString*) stringValue {
	return self;
}

@end

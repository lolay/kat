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

#import "UIColor+Lolay.h"

@implementation UIColor (Lolay)

+ (UIColor*) colorWithHex:(NSInteger) hexValue {
    return [UIColor colorWithRed:((CGFloat)((hexValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((hexValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(hexValue & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor*) colorWithDictionary:(NSDictionary*) dictionary {
	if (dictionary == nil) {
		return nil;
	}
	
	CGFloat red = [[dictionary objectForKey:@"red"] floatValue] / 255;
	CGFloat green = [[dictionary objectForKey:@"green"] floatValue] / 255;
	CGFloat blue = [[dictionary objectForKey:@"blue"] floatValue] / 255;
	CGFloat alpha = 1.0;
	NSNumber* alphaNumber = [dictionary objectForKey:@"alpha"];
	if (alphaNumber) {
		alpha = [alphaNumber floatValue];
	}
	
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

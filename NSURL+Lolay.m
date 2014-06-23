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

#import "NSURL+Lolay.h"

@implementation NSURL (Lolay)

- (NSString*) absoluteStringAsFileName {
    
    NSMutableString* filename = [[NSMutableString alloc] init];
    
    NSUInteger length = self.absoluteString.length;
    unichar buffer[length];
    [self.absoluteString getCharacters:buffer range:NSMakeRange(0, length)];
    
    for (unsigned int i=0; i<self.absoluteString.length; i++) {
        
        unichar character = buffer[i];
        if (character == 0x2d || character == 0x2e || (character >= 0x30 && character <= 0x39) || (character >= 0x41 && character <= 0x5a) || character == 0x5f || (character >= 0x61 && character <= 0x7a)) {
            [filename appendFormat:@"%C", character];
        } else {
            [filename appendFormat:@"%X", character];
        }
    }
    
    return [NSString stringWithString:filename];
}

- (NSString*) stringByPercentUnescaping:(NSString*) source {
	if (source == nil) {
		return nil;
	}
	
	NSString* result = [source stringByReplacingOccurrencesOfString:@"+" withString:@" "];
	result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return result;
}

- (NSDictionary*) queryParameters {
	NSString* query = [self query];
	
	if (query.length == 0) {
		return nil;
	}
	
	NSArray* parameterStrings = [query componentsSeparatedByString:@"&"];
	
	NSMutableDictionary* parameters = [[NSMutableDictionary alloc] initWithCapacity:parameterStrings.count];
	
	for (NSString* parameterString in parameterStrings) {
		NSArray* parameterSplit = [parameterString componentsSeparatedByString:@"="];
		if (parameterSplit.count != 2) {
			continue;
		}
		NSString* name = [self stringByPercentUnescaping:[parameterSplit objectAtIndex:0]];
		NSString* value = [self stringByPercentUnescaping:[parameterSplit objectAtIndex:1]];
		
		id previousValue = [parameters objectForKey:name];
		if (previousValue) {
			if ([previousValue isKindOfClass:[NSMutableArray class]]) {
				[((NSMutableArray*) previousValue) addObject:value];
			} else {
				NSMutableArray* arrayValue = [[NSMutableArray alloc] initWithCapacity:2];
				[arrayValue addObject:previousValue];
				[arrayValue addObject:value];
				
				[parameters removeObjectForKey:name];
				[parameters setObject:arrayValue forKey:name];
			}
		} else {
			[parameters setObject:value forKey:name];
		}
	}
	
	return parameters;
}

- (NSURL *)URLByAppendingQueryString:(NSString *)queryString {
    if (![queryString length]) {
        return self;
    }
	
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@", [self absoluteString],
                           [self query] ? @"&" : @"?", queryString];
    NSURL *theURL = [NSURL URLWithString:URLString];
    return theURL;
}


@end

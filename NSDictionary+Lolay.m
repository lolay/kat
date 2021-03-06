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

#import "NSDictionary+Lolay.h"

@implementation NSDictionary (Lolay)

- (NSDictionary*) dictionaryByAppendingObject:(id) object forKey:(id <NSCopying>)key {
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithDictionary:self];
	[dictionary setObject:object forKey:key];
	return dictionary;
}

- (NSDictionary*) dictionaryByRemovingObjectForKey:(id <NSCopying>) key {
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithDictionary:self];
	[dictionary removeObjectForKey:key];
	return dictionary;
}

- (id) safeObjectForKey:(id)key {
    id obj = [self objectForKey:key];
    if (obj == [NSNull null]) {
        obj = nil;
    }
    return obj;
}

@end

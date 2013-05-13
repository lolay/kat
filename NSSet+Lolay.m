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

#import "NSSet+Lolay.h"

@implementation NSSet (Lolay)

- (NSSet*) setByRemovingObject:(id) object {
	NSMutableSet* set = [[NSMutableSet alloc] initWithSet:self];
	[set removeObject:object];
	return set;
}

- (NSSet*) setByRemovingObjects:(NSSet*) objects {
	NSMutableSet* set = [[NSMutableSet alloc] initWithSet:self];
	for (id object in objects) {
		[set removeObject:object];
	}
	return set;
}

- (NSSet*) setByIntersectingSet:(NSSet*) objects {
	NSMutableSet* set = [self mutableCopy];
    [set intersectSet:objects];
	return set;
}

@end

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

#import "LolayCounter.h"

@interface LolayCounter ()

@property (nonatomic, assign, readwrite) NSInteger integerValue;

@end

@implementation LolayCounter

@synthesize integerValue = integerValue_;

+ (LolayCounter*) counter {
	return [[LolayCounter alloc] init];
}

+ (LolayCounter*) counterWithInteger:(NSInteger) integer {
	LolayCounter* counter = [[LolayCounter alloc] init];
	counter.integerValue = integer;
	return counter;
}

- (void) increment {
	self.integerValue = self.integerValue + 1;
}

- (void) decrement {
	if (self.integerValue > 0) {
		self.integerValue = self.integerValue - 1;
	}
}

- (void) reset {
	self.integerValue = 0;
}

@end

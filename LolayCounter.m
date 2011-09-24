//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import "LolayCounter.h"

@interface LolayCounter ()

@property (nonatomic, assign, readwrite) NSInteger integerValue;

@end

@implementation LolayCounter

@synthesize integerValue = integerValue_;

+ (LolayCounter*) counter {
	return [[[LolayCounter alloc] init] autorelease];
}

+ (LolayCounter*) counterWithInteger:(NSInteger) integer {
	LolayCounter* counter = [[[LolayCounter alloc] init] autorelease];
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

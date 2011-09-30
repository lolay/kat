//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import "LolayBackgroundToolbar.h"

@implementation LolayBackgroundToolbar

@synthesize backgroundImage = backgroundImage_;

- (void)drawRect:(CGRect)rect {
    if (self.backgroundImage != nil) {
		[self.backgroundImage drawInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
		
	} else {
		[super drawRect:rect];
	}
}

- (void) dealloc {
	self.backgroundImage = nil;
	
	[super dealloc];
}

@end

//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <objc/runtime.h>
#import "UINavigationBar+LolayBackgroundImage.h"

@implementation UINavigationBar (LolayBackgroundImage)

@dynamic backgroundImage;

static char backgroundImageKey;

- (void) setBackgroundImage:(UIImage*) inBackgroundImage {
	objc_setAssociatedObject(self, &backgroundImageKey, inBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage*) backgroundImage {
	return objc_getAssociatedObject(self, &backgroundImageKey);
}

- (void)drawRect:(CGRect)rect {
	if (self.backgroundImage != nil) {
		[self.backgroundImage drawInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
		
	} else {
		[super drawRect:rect];
	}
}
@end
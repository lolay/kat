//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import "LolayBackgroundNavigationBar.h"

@implementation LolayBackgroundNavigationBar

@synthesize backgroundImage = backgroundImage_;

+ (UINavigationController*) navigationControllerWithBackgroundImage:(UIImage*) image {
	UINavigationController* controller = [[[NSBundle mainBundle] loadNibNamed:@"LolayBackgroundNavigation" owner:nil options:nil] objectAtIndex:0];
	((LolayBackgroundNavigationBar*) controller.navigationBar).backgroundImage = image;
	return controller;
}

+ (UINavigationController*) navigationControllerWithBackgroundImage:(UIImage*) image tintColor:(UIColor*) tintColor {
	UINavigationController* controller = [LolayBackgroundNavigationBar navigationControllerWithBackgroundImage:image];
	controller.navigationBar.tintColor = tintColor;
	return controller;
}

- (void)drawRect:(CGRect) rect {
	if (self.backgroundImage != nil) {
		[self.backgroundImage drawInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
		
	} else {
		[super drawRect:rect];
	}
}

@end
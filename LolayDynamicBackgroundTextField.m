//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import "LolayDynamicBackgroundTextField.h"

@implementation LolayDynamicBackgroundTextField

@synthesize normalBackground = normalBackground_;
@synthesize activeBackground = activeBackground_;

- (id)initWithCoder:(NSCoder *)inCoder {
	if ((self = [super initWithCoder:inCoder])) {
		self.borderStyle = UITextBorderStyleNone;
		//Add left padding so text doesn't stick to the left wall
		self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
		self.leftViewMode = UITextFieldViewModeAlways;
		self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
		self.rightViewMode = UITextFieldViewModeAlways;
	}
	return self;
}

- (BOOL)becomeFirstResponder {
	[super becomeFirstResponder];
	self.background = self.activeBackground;
	[self setNeedsDisplay];
	return YES;
}

- (BOOL)resignFirstResponder {
	[super resignFirstResponder];
	self.background = self.normalBackground;
	[self setNeedsDisplay];
	return YES;
}

- (void) dealloc {
	self.normalBackground = nil;
	self.activeBackground = nil;
	[super dealloc];
}

@end

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

#import "LolayDynamicBackgroundTextField.h"

@implementation LolayDynamicBackgroundTextField

@synthesize normalBackground = normalBackground_;
@synthesize activeBackground = activeBackground_;

- (id) initWithCoder:(NSCoder*) inCoder {
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

- (BOOL) becomeFirstResponder {
	[super becomeFirstResponder];
	self.background = self.activeBackground;
	[self setNeedsDisplay];
	return YES;
}

- (BOOL) resignFirstResponder {
	[super resignFirstResponder];
	self.background = self.normalBackground;
	[self setNeedsDisplay];
	return YES;
}

@end

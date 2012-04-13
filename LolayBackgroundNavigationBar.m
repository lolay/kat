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
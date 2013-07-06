//
//  Copyright 2013 Lolay, Inc.
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
#import "UILabel+Lolay.h"

@implementation UILabel (Lolay)

- (void) lolayResizeHeightToFitTextWithMaxHeight:(CGFloat) maxHeight {
	CGSize tallSize = CGSizeMake(self.frame.size.width, maxHeight);
	CGSize resized = [self.text sizeWithFont:self.font constrainedToSize:tallSize];
	CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, resized.height);
	self.frame = frame;
}

- (void) lolayResizeHeightToFitText {
	[self lolayResizeHeightToFitTextWithMaxHeight:CGFLOAT_MAX];
}

@end

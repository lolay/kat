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

#import "LolayUnderlineButton.h"

#define DEFAULT_UNDERLINE YES
#define DEFAULT_HEIGHT 1.0

@implementation LolayUnderlineButton

@synthesize underlined = underlined_;
@synthesize underlineHeight = underlineHeight_;

- (void) initialize {
	self.underlined = DEFAULT_UNDERLINE;
	self.underlineHeight = DEFAULT_HEIGHT;
}

- (id) init {
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

- (id) initWithFrame:(CGRect) frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (id) initWithCoder:(NSCoder*) decoder {
	self = [super initWithCoder:decoder];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void) drawUnderline:(CGRect) rect {
	if (self.underlined) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSetStrokeColorWithColor(context, [self titleColorForState:self.state].CGColor);
		
		CGContextSetLineWidth(context, self.underlineHeight);
		
		CGSize size = [[self titleForState:self.state] sizeWithFont:self.titleLabel.font forWidth:rect.size.width lineBreakMode:self.titleLabel.lineBreakMode];
		CGFloat width = rect.size.width;
		CGFloat offset = (rect.size.width - size.width) / 2.0;
		if (offset > 0.0 && offset < rect.size.width) {
			width -= offset;
		} else {
			offset = 0.0;
		}
		
		CGFloat baseline = rect.size.height + self.titleLabel.font.descender + 2.0;
		
		// Draw a single line from left to right
		CGContextMoveToPoint(context, offset, baseline);
		CGContextAddLineToPoint(context, width, baseline);
		CGContextStrokePath(context);
	}
}

- (void) drawRect:(CGRect) rect {
	[super drawRect:rect];
	[self drawUnderline:rect];
}

@end

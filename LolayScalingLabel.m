//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import "LolayScalingLabel.h"

@implementation LolayScalingLabel

-(void) drawRect:(CGRect) rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	CGContextSetShouldSmoothFonts(context, true);
	CGContextSetShouldAntialias(context, false);
	[super drawRect:rect];
	CGContextRestoreGState(context);
}

@end
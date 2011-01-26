//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import "LolayScalingLabel.h"

@implementation LolayScalingLabel

-(void) drawRect:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState( context );
    CGContextSetShouldSmoothFonts( context , true );
	CGContextSetShouldAntialias( context , false );
    [super drawRect:r];
    CGContextRestoreGState( context );
}

@end

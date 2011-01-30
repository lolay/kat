//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface LolayDynamicBackgroundTextField : UITextField 
	
@property (nonatomic, retain) UIImage* normalBackground;
@property (nonatomic, retain) UIImage* activeBackground;

- (id)initWithCoder:(NSCoder *)inCoder;

@end

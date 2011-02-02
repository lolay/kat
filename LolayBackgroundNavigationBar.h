//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface LolayBackgroundNavigationBar : UINavigationBar

@property (nonatomic, retain) UIImage* backgroundImage;

+ (UINavigationController*) navigationControllerWithBackgroundImage:(UIImage*) image;

@end
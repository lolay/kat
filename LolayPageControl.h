//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <UIKit/UIControl.h>
#import <UIKit/UIKitDefines.h>

typedef enum
{
	LolayPageControlTypeOnFullOffFull		= 0,
	LolayPageControlTypeOnFullOffEmpty		= 1,
	LolayPageControlTypeOnEmptyOffFull		= 2,
	LolayPageControlTypeOnEmptyOffEmpty     = 3,
} LolayPageControlType;


@interface LolayPageControl : UIControl {
	NSInteger numberOfPages;
	NSInteger currentPage;
}

// Replicate UIPageControl features
@property(nonatomic) NSInteger numberOfPages;
@property(nonatomic) NSInteger currentPage;

@property(nonatomic) BOOL hidesForSinglePage;

@property(nonatomic) BOOL defersCurrentPageDisplay;
- (void)updateCurrentPageDisplay;

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

/*
 LolayPageControl add-ons - all these parameters are optional
 Not using any of these parameters produce a page control identical to Apple's UIPage control
 */
- (id)initWithType:(LolayPageControlType)theType;

@property (nonatomic) LolayPageControlType type;

@property (nonatomic,retain) UIColor *onColor;
@property (nonatomic,retain) UIColor *offColor;

@property (nonatomic) CGFloat indicatorDiameter;
@property (nonatomic) CGFloat indicatorSpace;


@end

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

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

#import <UIKit/UIKit.h>

typedef enum {
	FrontViewPositionLeft,
	FrontViewPositionRight
} LolayUIRevealFrontViewPosition;

@protocol LolayUIRevealControllerDelegate;

@interface LolayUIRevealController : UIViewController <UITableViewDelegate>

// Public Properties:
@property (strong, nonatomic) IBOutlet UIViewController* frontViewController;
@property (strong, nonatomic) IBOutlet UIViewController* rearViewController;
@property (assign, nonatomic) LolayUIRevealFrontViewPosition currentFrontViewPosition;
@property (assign, nonatomic) id<LolayUIRevealControllerDelegate> delegate;

// Public Methods:
- (id)initWithFrontViewController:(UIViewController*)aFrontViewController rearViewController:(UIViewController*)aBackViewController;
- (id)initWithFrontViewController:(UIViewController*)aFrontViewController rearViewController:(UIViewController*)aBackViewController revealOffset:(CGFloat)revealOffset;
- (void)revealGesture:(UIPanGestureRecognizer*)recognizer;
- (void)revealToggle:(id)sender;

- (void)setFrontViewController:(UIViewController*)frontViewController;
- (void)setFrontViewController:(UIViewController*)frontViewController animated:(BOOL)animated;

- (void)setRevealOffset:(CGFloat)revealOffset;

@end

@protocol LolayUIRevealControllerDelegate<NSObject>

@optional

- (BOOL)revealController:(LolayUIRevealController*)revealController shouldRevealRearViewController:(UIViewController*)rearViewController;
- (BOOL)revealController:(LolayUIRevealController*)revealController shouldHideRearViewController:(UIViewController*)rearViewController;

/* 
 * IMPORTANT: It is not guaranteed that 'didReveal...' will be called after 'willReveal...'. The user 
 * might not have panned far enough for a reveal to be triggered! Thus 'didHide...' will be called!
 */
- (void)revealController:(LolayUIRevealController*)revealController willRevealRearViewController:(UIViewController*)rearViewController;
- (void)revealController:(LolayUIRevealController*)revealController didRevealRearViewController:(UIViewController*)rearViewController;

- (void)revealController:(LolayUIRevealController*)revealController willHideRearViewController:(UIViewController*)rearViewController;
- (void)revealController:(LolayUIRevealController*)revealController didHideRearViewController:(UIViewController*)rearViewController;

- (void)revealController:(LolayUIRevealController*)revealController willSwapToFrontViewController:(UIViewController*)frontViewController;
- (void)revealController:(LolayUIRevealController*)revealController didSwapToFrontViewController:(UIViewController*)frontViewController;

@end
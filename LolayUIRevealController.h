//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//  Based on zuui.org
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
- (void)revealGesture:(UIPanGestureRecognizer*)recognizer;
- (void)revealToggle:(id)sender;

- (void)setFrontViewController:(UIViewController*)frontViewController;
- (void)setFrontViewController:(UIViewController*)frontViewController animated:(BOOL)animated;

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
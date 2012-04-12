//
//  Copyright 2012 Lolay, Inc. All rights reserved.
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

// Required for the shadow cast by the front view.
#import <QuartzCore/QuartzCore.h>
#import "LolayUIRevealController.h"

/*
* NOTE: Before editing the values below make sure they make 'sense'. Unexpected behavior might occur if for instance the 'REVEAL_EDGE'
*		 were to be lower than the left trigger level...
*/

// 'REVEAL_EDGE' defines the point on the x-axis up to which the rear view is shown.
#define REVEAL_EDGE 280.0f

// 'REVEAL_EDGE_OVERDRAW' defines the maximum offset that can occur after the 'REVEAL_EDGE' has been reached.
#define REVEAL_EDGE_OVERDRAW 60.0f

// 'REVEAL_VIEW_TRIGGER_LEVEL_LEFT' defines the least amount of offset that needs to be panned until the front view snaps to the right edge.
#define REVEAL_VIEW_TRIGGER_LEVEL_LEFT 125.0f

// 'REVEAL_VIEW_TRIGGER_LEVEL_RIGHT' defines the least amount of translation that needs to be panned until the front view snaps _BACK_ to the left edge.
#define REVEAL_VIEW_TRIGGER_LEVEL_RIGHT 200.0f

// 'VELOCITY_REQUIRED_FOR_QUICK_FLICK' is the minimum speed of the finger required to instantly trigger a reveal/hide.
#define VELOCITY_REQUIRED_FOR_QUICK_FLICK 1300.0f

@interface LolayUIRevealController()

@property (strong, nonatomic) UIView* frontView;
@property (strong, nonatomic) UIView* rearView;
@property (assign, nonatomic) float previousPanOffset;

- (CGFloat)calculateOffsetForTranslationInView:(CGFloat)x;
- (void)revealAnimation;
- (void)concealAnimation;

- (void)addFrontViewControllerToHierarchy:(UIViewController*)frontViewController;
- (void)addRearViewControllerToHierarchy:(UIViewController*)rearViewController;
- (void)removeFrontViewControllerFromHierarchy:(UIViewController*)frontViewController;
- (void)removeRearViewControllerFromHierarchy:(UIViewController*)rearViewController;
- (void)swapCurrentFrontViewControllerWith:(UIViewController*)newFrontViewController animated:(BOOL)animated;

@end

@implementation LolayUIRevealController

@synthesize previousPanOffset = previousPanOffset_;
@synthesize currentFrontViewPosition = currentFrontViewPosition_;
@synthesize frontViewController = frontViewController_;
@synthesize rearViewController = rearViewController_;
@synthesize frontView = frontView_;
@synthesize rearView = rearView_;
@synthesize delegate = _delegate;

#pragma mark - Initialization

- (id)initWithFrontViewController:(UIViewController*)aFrontViewController rearViewController:(UIViewController*)aBackViewController {
	self = [super init];	
	if (nil != self) {
		frontViewController_ = aFrontViewController;
		rearViewController_ = aBackViewController;
	}
	return self;
}

#pragma mark - Reveal Callbacks

// Slowly reveal or hide the rear view based on the translation of the finger.
- (void)revealGesture:(UIPanGestureRecognizer*)recognizer {	
	// 1. Ask the delegate (if appropriate) if we are allowed to do the particular interaction:
	if ([self.delegate conformsToProtocol:@protocol(LolayUIRevealControllerDelegate)]) {
		// Case a): We're going to be revealing.
		if (FrontViewPositionLeft == self.currentFrontViewPosition)	{
			if ([self.delegate respondsToSelector:@selector(revealController:shouldRevealRearViewController:)])	{
				if (![self.delegate revealController:self shouldRevealRearViewController:self.rearViewController]) {
					return;
				}
			}
		} else {    // Case b): We're going to be concealing.
			if ([self.delegate respondsToSelector:@selector(revealController:shouldHideRearViewController:)]) {
				if (![self.delegate revealController:self shouldHideRearViewController:self.rearViewController]) {
					return;
				}
			}
		}
	}
	
	// 2. Now that we've know we're here, we check whether we're just about to _START_ an interaction,...
	if (UIGestureRecognizerStateBegan == [recognizer state]) {
		// Check if a delegate exists
		if ([self.delegate conformsToProtocol:@protocol(LolayUIRevealControllerDelegate)]) {
			// Determine whether we're going to be revealing or hiding.
			if (FrontViewPositionLeft == self.currentFrontViewPosition) {
				if ([self.delegate respondsToSelector:@selector(revealController:willRevealRearViewController:)]) {
					[self.delegate revealController:self willRevealRearViewController:self.rearViewController];
				}
			} else {
				if ([self.delegate respondsToSelector:@selector(revealController:willHideRearViewController:)])	{
					[self.delegate revealController:self willHideRearViewController:self.rearViewController];
				}
			}
		}
	}
	
	// 3. ...or maybe the interaction already _ENDED_?
	if (UIGestureRecognizerStateEnded == [recognizer state]) {
		// Case a): Quick finger flick fast enough to cause instant change:
		if (fabs([recognizer velocityInView:self.view].x) > VELOCITY_REQUIRED_FOR_QUICK_FLICK) {
			if ([recognizer velocityInView:self.view].x > 0.0f) {				
				[self revealAnimation];
			} else {
				[self concealAnimation];
			}
		} else {    // Case b) Slow pan/drag ended:
			float dynamicTriggerLevel = (FrontViewPositionLeft == self.currentFrontViewPosition) ? REVEAL_VIEW_TRIGGER_LEVEL_LEFT : REVEAL_VIEW_TRIGGER_LEVEL_RIGHT;
			
			if (self.frontView.frame.origin.x >= dynamicTriggerLevel && self.frontView.frame.origin.x != REVEAL_EDGE) {
				[self revealAnimation];
			}
			else if (self.frontView.frame.origin.x < dynamicTriggerLevel && self.frontView.frame.origin.x != 0.0f) {
				[self concealAnimation];
			}
		}
		
		// Now adjust the current state enum.
		if (self.frontView.frame.origin.x == 0.0f) {
			self.currentFrontViewPosition = FrontViewPositionLeft; 
        } else {
			self.currentFrontViewPosition = FrontViewPositionRight;
		}
		
		return;
	}
	
	// 4. None of the above? That means it's _IN PROGRESS_!
	if (FrontViewPositionLeft == self.currentFrontViewPosition)	{
		if ([recognizer translationInView:self.view].x < 0.0f) {
			self.frontView.frame = CGRectMake(0.0f, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
		} else {
			float offset = [self calculateOffsetForTranslationInView:[recognizer translationInView:self.view].x];
			self.frontView.frame = CGRectMake(offset, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
		}
	} else {
		if ([recognizer translationInView:self.view].x > 0.0f) {
			float offset = [self calculateOffsetForTranslationInView:([recognizer translationInView:self.view].x+REVEAL_EDGE)];
			self.frontView.frame = CGRectMake(offset, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
		} else if ([recognizer translationInView:self.view].x > -REVEAL_EDGE) {
			self.frontView.frame = CGRectMake([recognizer translationInView:self.view].x+REVEAL_EDGE, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
		} else {
			self.frontView.frame = CGRectMake(0.0f, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
		}
	}
}

// Instantaneously toggle the rear view's visibility.
- (void)revealToggle:(id)sender {	
	if (FrontViewPositionLeft == self.currentFrontViewPosition) {
		// Check if a delegate exists and if so, whether it is fine for us to revealing the rear view.
		if ([self.delegate respondsToSelector:@selector(revealController:shouldRevealRearViewController:)]) {
			if (![self.delegate revealController:self shouldRevealRearViewController:self.rearViewController]) {
				return;
			}
		}
		
		// Dispatch message to delegate, telling it the 'rearView' _WILL_ reveal, if appropriate:
		if ([self.delegate respondsToSelector:@selector(revealController:willRevealRearViewController:)]) {
			[self.delegate revealController:self willRevealRearViewController:self.rearViewController];
		}
		
		[self revealAnimation];		
		self.currentFrontViewPosition = FrontViewPositionRight;
	} else {
		// Check if a delegate exists and if so, whether it is fine for us to hiding the rear view.
		if ([self.delegate respondsToSelector:@selector(revealController:shouldHideRearViewController:)]) {
			if (![self.delegate revealController:self shouldHideRearViewController:self.rearViewController]) {
				return;
			}
		}
		
		// Dispatch message to delegate, telling it the 'rearView' _WILL_ hide, if appropriate:
		if ([self.delegate respondsToSelector:@selector(revealController:willHideRearViewController:)]) {
			[self.delegate revealController:self willHideRearViewController:self.rearViewController];
		}
		
		[self concealAnimation];		
		self.currentFrontViewPosition = FrontViewPositionLeft;
	}
}

- (void)setFrontViewController:(UIViewController*)frontViewController {
	[self setFrontViewController:frontViewController animated:NO];
}

- (void)setFrontViewController:(UIViewController*)frontViewController animated:(BOOL)animated {
	if (nil != frontViewController && self.frontViewController == frontViewController) {
		[self revealToggle:nil];
	} else if (nil != frontViewController) {
		[self swapCurrentFrontViewControllerWith:frontViewController animated:animated];
	}
}

#pragma mark - Helper

- (void)revealAnimation {	
	[UIView animateWithDuration:0.25f animations:^ {
            self.frontView.frame = CGRectMake(REVEAL_EDGE, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
        } completion:^(BOOL finished) {
            // Dispatch message to delegate, telling it the 'rearView' _DID_ reveal, if appropriate:
            if ([self.delegate respondsToSelector:@selector(revealController:didRevealRearViewController:)]) {
                [self.delegate revealController:self didRevealRearViewController:self.rearViewController];
            }
	}];
}

- (void)concealAnimation {	
	[UIView animateWithDuration:0.25f animations:^ {
            self.frontView.frame = CGRectMake(0.0f, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
        } completion:^(BOOL finished) {
            // Dispatch message to delegate, telling it the 'rearView' _DID_ hide, if appropriate:
            if ([self.delegate respondsToSelector:@selector(revealController:didHideRearViewController:)]) {
                [self.delegate revealController:self didHideRearViewController:self.rearViewController];
            }
	}];
}

- (CGFloat)calculateOffsetForTranslationInView:(CGFloat)x {
	CGFloat result;	
	if (x <= REVEAL_EDGE) {        // Translate linearly
		result = x;
	} else if (x <= REVEAL_EDGE+(M_PI*REVEAL_EDGE_OVERDRAW/2.0f)) {     		// and eventually slow translation slowly
		result = REVEAL_EDGE_OVERDRAW*sin((x-REVEAL_EDGE)/REVEAL_EDGE_OVERDRAW)+REVEAL_EDGE;
	} else {                    // ...until we hit the limit.
		result = REVEAL_EDGE+REVEAL_EDGE_OVERDRAW;
	}
	
	return result;
}

- (void)swapCurrentFrontViewControllerWith:(UIViewController*)newFrontViewController animated:(BOOL)animated {
	if ([self.delegate respondsToSelector:@selector(revealController:willSwapToFrontViewController:)]) {
		[self.delegate revealController:self willSwapToFrontViewController:newFrontViewController];
	}
	
	CGFloat xSwapOffsetExpanded;
	CGFloat xSwapOffsetNormal;
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)	{
		xSwapOffsetExpanded = [[UIScreen mainScreen] bounds].size.width;
		xSwapOffsetNormal = 0.0f;
	} else {
		xSwapOffsetExpanded = self.frontView.frame.origin.x;
		xSwapOffsetNormal = self.frontView.frame.origin.x;
	}
	
	if (animated) {
		[UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
                self.frontView.frame = CGRectMake(xSwapOffsetExpanded, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
            } completion:^(BOOL finished) {
                [self removeFrontViewControllerFromHierarchy:self.frontViewController];
                frontViewController_ = newFrontViewController;
                [self addFrontViewControllerToHierarchy:newFrontViewController];	
                
                [UIView animateWithDuration:0.225f delay:0.0f options:UIViewAnimationCurveEaseIn animations:^{
                        self.frontView.frame = CGRectMake(xSwapOffsetNormal, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
                    }
                    completion:^(BOOL finished) {
                        [self revealToggle:self];                          
                        if ([self.delegate respondsToSelector:@selector(revealController:didSwapToFrontViewController:)]) {
                            [self.delegate revealController:self didSwapToFrontViewController:newFrontViewController];
                        }
                }];
		}];
	} else {
		[self removeFrontViewControllerFromHierarchy:self.frontViewController];
		[self addFrontViewControllerToHierarchy:newFrontViewController];		
		frontViewController_ = newFrontViewController;		
        
		if ([self.delegate respondsToSelector:@selector(revealController:didSwapToFrontViewController:)]) {
			[self.delegate revealController:self didSwapToFrontViewController:newFrontViewController];
		}
		
		[self revealToggle:self];
	}
}

#pragma mark - UIViewController Containment

- (void)addFrontViewControllerToHierarchy:(UIViewController*)frontViewController {
	[self addChildViewController:frontViewController];
	[self.frontView addSubview:frontViewController.view];
		
	if ([frontViewController respondsToSelector:@selector(didMoveToParentViewController:)]) {
		[frontViewController didMoveToParentViewController:self];
	}
}

- (void)addRearViewControllerToHierarchy:(UIViewController*)rearViewController {
	[self addChildViewController:rearViewController];
	[self.rearView addSubview:rearViewController.view];

	if ([rearViewController respondsToSelector:@selector(didMoveToParentViewController:)]) {
		[rearViewController didMoveToParentViewController:self];
	}
}

- (void)removeFrontViewControllerFromHierarchy:(UIViewController*)frontViewController {
	[frontViewController.view removeFromSuperview];
	if ([frontViewController respondsToSelector:@selector(removeFromParentViewController:)]) {
		[frontViewController removeFromParentViewController];		
	}
}

- (void)removeRearViewControllerFromHierarchy:(UIViewController*)rearViewController {
	[rearViewController.view removeFromSuperview];
	if ([rearViewController respondsToSelector:@selector(removeFromParentViewController:)])	{
		[rearViewController removeFromParentViewController];
	}
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.frontView = [[UIView alloc] initWithFrame:self.view.bounds];
	self.rearView = [[UIView alloc] initWithFrame:self.view.bounds];
	
	self.frontView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.rearView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	
	[self.view addSubview:self.rearView];
	[self.view addSubview:self.frontView];
	
	/* Create a fancy shadow aroung the frontView.
	*
	* Note: UIBezierPath needed because shadows are evil. If you don't use the path, you might not
	* not notice a difference at first, but the keen eye will (even on an iPhone 4S) observe that 
	* the interface rotation _WILL_ lag slightly and feel less fluid than with the path.
	*/
	UIBezierPath*shadowPath = [UIBezierPath bezierPathWithRect:self.frontView.bounds];
	self.frontView.layer.masksToBounds = NO;
	self.frontView.layer.shadowColor = [UIColor blackColor].CGColor;
	self.frontView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
	self.frontView.layer.shadowOpacity = 1.0f;
	self.frontView.layer.shadowRadius = 2.5f;
	self.frontView.layer.shadowPath = shadowPath.CGPath;
	
	// Init the position with only the front view visible.
	self.previousPanOffset = 0.0f;
	self.currentFrontViewPosition = FrontViewPositionLeft;
	
	[self addRearViewControllerToHierarchy:self.rearViewController];
	[self addFrontViewControllerToHierarchy:self.frontViewController];	
}

- (void)viewDidUnload {
	[self removeRearViewControllerFromHierarchy:self.frontViewController];
	[self removeFrontViewControllerFromHierarchy:self.frontViewController];
	
	self.frontView = nil;
    self.rearView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Memory Management

- (void)dealloc {
	self.frontViewController = nil;
    self.rearViewController = nil;
	self.frontView = nil;
	self.rearView = nil;
}

@end
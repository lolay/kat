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

#import "LolaySearchController.h"

@interface UISearchBar(LolaySearchController)

@end

@implementation UISearchBar(LolaySearchController)

- (BOOL)resignFirstResponder {
    
    
    // This is our one bit of hackery.. We are going to keep our cancel button
    // enabled and hide the keyboard by walking the view heirarchy..
    for (UIView *view in self.subviews)
    {
        for (id subview in view.subviews)
        {
            if ( [subview isKindOfClass:[UIButton class]] )
            {
                [subview setEnabled:YES];
            }
            
            if ([subview isKindOfClass:[UITextField class]]) {
                [(UITextField *)subview resignFirstResponder];
            }
        }
    }
    
    return YES;
}

- (void)enableCancelButton:(UISearchBar *)searchBar
{
    for (UIView *view in searchBar.subviews)
    {
        for (id subview in view.subviews)
        {
            if ( [subview isKindOfClass:[UIButton class]] )
            {
                [subview setEnabled:YES];
                [subview setUserInteractionEnabled:YES];
                NSLog(@"enableCancelButton");
                return;
            }
        }
    }
}

@end

@interface LolaySearchController()

@property (nonatomic, strong) NSLayoutConstraint *contentViewBottomConstraint;
@property (nonatomic, strong) UIScrollView* parentScrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL shouldBeginEditing;

// we need to keep track of the old buttons if there were some.
@property (nonatomic, copy) NSArray* leftBarItems;
@property (nonatomic, copy) NSArray* rightBarItems;
@property (nonatomic, strong) UIBarButtonItem *backBarItem;
@property (nonatomic, assign) CGRect originalRect;
@end

@implementation LolaySearchController

-(void) awakeFromNib {
    [super awakeFromNib];
    
     UIView* owningView = self.contentsController.view;
            self.shouldBeginEditing = YES;
    if (self.viewNibName != nil) {
        

        
        UINib *nib = [UINib nibWithNibName:self.viewNibName bundle:[self bundle]];
        if ([owningView isKindOfClass:[UIScrollView class]]) {
            self.parentScrollView = (UIScrollView *)owningView;
        }
        
        
        // if we found our nib then we need to go ahead and load the content view..
        if (nib != nil) {
        
            self.contentView = [nib instantiateWithOwner:self options:nil][0];
            self.contentView.hidden = YES;
            [owningView addSubview:self.contentView];
        }
    }
    else
    {
        CGRect frame = owningView.bounds;
        
        frame.origin.y = self.contentsController.topLayoutGuide.length;
            self.contentView = [[UIView alloc] initWithFrame:owningView.bounds];
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
            self.contentView.hidden = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
            [owningView addSubview:self.contentView];
    }
    
        // we want to be the search bar delegate.
        self.searchBar.delegate = self;
        self.searchBar.clipsToBounds = YES;
        
        // if we got a content view we want to go ahead and setup our constraints..
        if (self.contentsController != nil) {
            
            CGRect frame = self.contentsController.view.bounds;
            
            self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            
            frame = CGRectInset(frame, 0, self.contentsController.topLayoutGuide.length);
            
            self.contentView.frame = frame;
        
        
        // listen for keyboard changes..
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    }
}

-(void) hideKeyboard {
   
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSBundle *)bundle {
    return [NSBundle bundleForClass:[self class]];
}


-(UIBarPosition) positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

-(void) setActive:(BOOL)active {
    // when we become active we want to set the searchbar's first responder..
    // when we give up being active we will reset our search bar and UI.
    
    if (active == _active)
        return;
    
    _active = active;
    
    if (active) {
        
        // set thie navigation bar flag depending on our parent type.
        //self.isInNavigationBar = [self.searchBar.superview isKindOfClass:[UINavigationBar class]];

        // if our parent is a navigation bar we need to do a bit of work..
        if (self.isInNavigationBar) {
            
            // set the is InNavibat
            self.isInNavigationBar = YES;
            
            // get the bar.
            UINavigationBar* bar = (UINavigationBar *)self.searchBar.superview.superview;
            
            // get the item.
            UINavigationItem *item = bar.items[0];
            
            // stash left, right, and back items.
            self.leftBarItems = item.leftBarButtonItems;
            self.backBarItem = item.backBarButtonItem;
            self.rightBarItems = item.rightBarButtonItems;
            
            // set the items to null so our search box grows.
            [item setLeftBarButtonItems:nil animated:YES];
            [item setRightBarButtonItems:nil animated:YES];
            item.rightBarButtonItems  = nil;
            
            [bar layoutSubviews];
        }
        else {
            [self.contentsController.navigationController setNavigationBarHidden:YES animated:YES];
        }

        
        
        
        self.contentView.hidden = NO;
        self.searchBar.clipsToBounds = NO;
        
        // if the search bar is not the first responder then become it.
        if (self.searchBar.isFirstResponder)
            [self.searchBar becomeFirstResponder];
        
        self.originalRect = self.searchBar.superview.frame;
        
        if (self.isInNavigationBar) {
            [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                CGRect other = self.originalRect;
                other.origin.x = 0;
                other.size.width = self.searchBar.superview.superview.bounds.size.width;
                self.searchBar.superview.frame = other;
            }completion:nil];
        }
        
        
        
        [self.searchBar setShowsCancelButton:YES animated:YES];
        if (self.parentScrollView != nil) {
            self.parentScrollView.scrollEnabled = NO;
        }

    }
    else {
        // if we are in the navigation bar restore our items.
        if (self.isInNavigationBar) {
            
            UINavigationBar* bar = (UINavigationBar *)self.searchBar.superview.superview;
            
            
            UINavigationItem *item = bar.items[0];

            [item setLeftBarButtonItems:self.leftBarItems animated:YES];
            [item setRightBarButtonItems:self.rightBarItems animated:YES];

            item.backBarButtonItem = self.backBarItem;
            
            self.leftBarItems = nil;
            self.rightBarItems = nil;
            self.backBarItem = nil;
        }
        else {
            [self.contentsController.navigationController setNavigationBarHidden:NO animated:YES];
        }
        
        self.searchBar.text = @"";
        self.searchBar.clipsToBounds = YES;
        
        [self.searchBar resignFirstResponder];
        self.contentView.hidden = YES;
       
        [self.searchBar setShowsCancelButton:NO animated:YES];
        
        if (self.isInNavigationBar) {
            [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.searchBar.superview.frame = self.originalRect;
            }completion:nil];
        }
        
         [self.contentsController.navigationController setNavigationBarHidden:NO animated:NO];
        
        if (self.parentScrollView != nil) {
            self.parentScrollView.scrollEnabled = YES;
        }
    }
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    // be default we want to beomce active..
    [self setActive:YES];

    return YES;
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // cancel pressed we need to just set ourselves to not being active.
    [self setActive:NO];
}

- (CGRect)calculateClientFrameUsingKeyboardFrame:(CGRect)keyboardFrame {
    
    BOOL isPortrait = UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    CGFloat height = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width;

    // get our status bar height.
    CGRect statusbarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat statusBarHeight = isPortrait ? statusbarFrame.size.height : statusbarFrame.size.width;
    
    // get our window bounds.
    CGRect frame = self.contentsController.view.bounds;
    
    if (!self.isInNavigationBar) {
    // if we are landscape flip our frame around.
    if (!isPortrait) {
        CGFloat tempHeight = CGRectGetWidth(frame);
        
        frame.size.width = frame.size.height;
        frame.size.height = tempHeight;
    }
    // calucate the height.
    frame.size.height -= height + statusBarHeight + CGRectGetHeight(self.searchBar.bounds);
    
    // put just below the search bar.
    frame.origin.y = CGRectGetMaxY(self.searchBar.frame);
    }
    else {
        
        // calucate the height.
       // frame.size.height -= height - statusBarHeight;

        frame.size.height -= self.contentsController.topLayoutGuide.length;
        
        frame.origin.y = self.contentsController.topLayoutGuide.length;
    }
    
    return frame;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    
    // get the keyboard informatoin we need.
    CGRect keyboardFrame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // make our curve an option..
    NSInteger curve = [info[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    
    CGRect frame = [self calculateClientFrameUsingKeyboardFrame:keyboardFrame];
    
    [self.contentsController.view bringSubviewToFront:self.contentView];
    
    // animate the frame change.
    [UIView animateWithDuration:animationDuration delay:0
                        options:curve | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews
                     animations:^{
        
                         self.contentView.frame = frame;
    }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notificaton {
    NSDictionary *info = [notificaton userInfo];
    NSTimeInterval animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.contentViewBottomConstraint.constant = 0;
    [self.contentsController.view setNeedsUpdateConstraints];
    
    // make our curve an option..
    NSInteger curve = [info[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    
    CGRect frame = [self calculateClientFrameUsingKeyboardFrame:CGRectZero];
    
    [self.contentsController.view bringSubviewToFront:self.contentView];
    
    // animate the frame change. (always to be consistent).
    [UIView animateWithDuration:animationDuration delay:0
                        options:curve | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         
                         self.contentView.frame = frame;
                     }
                     completion:nil];
}


-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}


@end

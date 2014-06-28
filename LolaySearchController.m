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
                NSLog(@"enableCancelButton");
            }
            
            if ([subview isKindOfClass:[UITextField class]]) {
                [(UITextField *)subview resignFirstResponder];
            }
        }
    }
    
    return YES;
}


@end

@interface LolaySearchController()

@property (nonatomic, strong) NSLayoutConstraint *contentViewBottomConstraint;
@property (nonatomic, strong) UIScrollView* parentScrollView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation LolaySearchController

-(void) awakeFromNib {
    [super awakeFromNib];
    
    if (self.viewNibName != nil) {
        
        UIView* owningView = self.contentsController.view;
        
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
        
        // we want to be the search bar delegate.
        self.searchBar.delegate = self;
        self.searchBar.clipsToBounds = YES;
        
        // if we got a content view we want to go ahead and setup our constraints..
        if (self.contentView != nil) {
            
            CGRect frame = owningView.bounds;
            CGRect searcBarFrame = self.searchBar.frame;
            
            frame = CGRectInset(frame, 0, searcBarFrame.size.height);
            
            self.contentView.frame = frame;
        }
        
        // listen for keyboard changes..
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    }
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
        [self.contentsController.navigationController setNavigationBarHidden:YES animated:YES];
        
        self.searchBar.showsCancelButton = YES;
        self.contentView.hidden = NO;
        self.searchBar.clipsToBounds = NO;
        
        // if the search bar is not the first responder then become it.
        if (self.searchBar.isFirstResponder)
            [self.searchBar becomeFirstResponder];
        
        if (self.parentScrollView != nil) {
            self.parentScrollView.scrollEnabled = NO;
        }

    }
    else {
        self.searchBar.text = @"";
        self.searchBar.clipsToBounds = YES;
        
        [self.searchBar resignFirstResponder];
        self.contentView.hidden = YES;
       
        self.searchBar.showsCancelButton = NO;
        
         [self.contentsController.navigationController setNavigationBarHidden:NO animated:YES];
        
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
    CGRect frame = self.contentsController.view.window.bounds;
    
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

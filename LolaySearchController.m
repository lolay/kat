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

-(UIBarPosition) barPosition {
   return UIBarPositionTopAttached;
}

@end

@interface LolaySearchController()<UISearchBarDelegate>

@property (nonatomic, strong) UITableView *resultsTableView;
@property (nonatomic, strong) NSLayoutConstraint *contentViewBottomConstraint;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation LolaySearchController

-(void) awakeFromNib {
    [super awakeFromNib];
    
    if (self.viewNibName != nil) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  
        UIView* owningView = self.contentsController.view;
        UINib *nib = [UINib nibWithNibName:self.viewNibName bundle:bundle];
        
        // if we found our nib then we need to go ahead and load the content view..
        if (nib != nil) {
        
            self.contentView = [nib instantiateWithOwner:self options:nil][0];
            self.contentView.frame = CGRectZero;
            [self.contentView  setTranslatesAutoresizingMaskIntoConstraints:NO];
            self.contentView.hidden = YES;
            [self.contentsController.view addSubview:self.contentView];
        }
        
        // we want to be the search bar delegate.
        self.searchBar.delegate = self;
        
        // if we got a content view we want to go ahead and setup our constraints..
        if (self.contentView != nil) {
            NSDictionary *views = NSDictionaryOfVariableBindings(_searchBar, _contentView);
            
            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_searchBar]-[_contentView]|" options:0 metrics:nil views:views];

            // grab our constraint for the bottom.. We will adjust this when we hear the keyboard comming.
            self.contentViewBottomConstraint = [constraints lastObject];

            [owningView addConstraints:constraints];

            [owningView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:0 metrics:nil views:views]];
        }
        
        // listen for keyboard changes..
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    }
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        // if the search bar is not the first responder then become it.
        if (self.searchBar.isFirstResponder)
            [self.searchBar becomeFirstResponder];

    }
    else {
        self.searchBar.text = @"";
        
        [self.searchBar resignFirstResponder];
        self.contentView.hidden = YES;
       
        self.searchBar.showsCancelButton = NO;
        
         [self.contentsController.navigationController setNavigationBarHidden:NO animated:YES];
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

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    
    // get the keyboard informatoin we need.
    CGRect keyboardFrame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // get the proper height. This becomes our offset from the bottom.
    BOOL isPortrait = UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    CGFloat height = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width;
    NSLog(@"The keyboard height is: %f", height);

    // make our curve an option..
    NSInteger curve = [info[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    
    self.contentViewBottomConstraint.constant = height;
    [self.contentsController.view setNeedsUpdateConstraints];
    
    // animate the frame change.
    [UIView animateWithDuration:animationDuration delay:0
                        options:curve | UIViewAnimationOptionOverrideInheritedOptions
                     animations:^{
        
                         [self.contentsController.view layoutIfNeeded];
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
    
    // animate the frame change.
    [UIView animateWithDuration:animationDuration delay:0
                        options:UIViewAnimationOptionOverrideInheritedOptions | curve
                     animations:^{
                         
                         [self.contentsController.view layoutIfNeeded];
                     }
                     completion:nil];
}

@end

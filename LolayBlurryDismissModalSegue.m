//
//  Copyright 2014 Lolay, Inc.
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

#import "LolayBlurryDismissModalSegue.h"

@implementation LolayBlurryDismissModalSegue

- (void)perform
{
    UIViewController* sourceController = (UIViewController*)self.sourceViewController;
    
    CGRect windowBounds = sourceController.view.window.bounds;
    
    // Normalize based on the orientation
    CGRect nomalizedWindowBounds = [sourceController.view convertRect:windowBounds fromView:nil];

    
    // we expect source to have a background view.
    UIView *backgroundImageView = sourceController.view.subviews[0];
                      
    // we just need to set the content view to be pinned to the bottom.
    backgroundImageView.contentMode = UIViewContentModeBottom;
    
    sourceController.view.clipsToBounds = YES;
    
    [sourceController dismissViewControllerAnimated:YES completion:nil];
    
    [sourceController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [UIView animateWithDuration:[context transitionDuration] animations:^{
            
            if (sourceController.modalTransitionStyle == UIModalTransitionStyleCoverVertical) {
                backgroundImageView.frame = CGRectMake(0, 0, nomalizedWindowBounds.size.width, 0);
            }
        }];
        
    } completion:nil];;
}

@end

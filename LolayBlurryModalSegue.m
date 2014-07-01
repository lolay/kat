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

#import "LolayBlurryModalSegue.h"
#import "UIImage+ImageEffects.m"

@implementation LolayBlurryModalSegue

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    
    if (self)
    {
        // Some sane defaults
        self.blurRadius = 20.0;
        [UIColor colorWithWhite:1.0 alpha:0.3];
        self.saturationDeltaFactor = 1.85;
    }
    
    return self;
}

-(void) setPreset:(LolayBlurryModalSeguePreset)preset {
    _preset = preset;
    
    switch (preset) {
        case LolayBlurryModalSeguePresetLight:
            self.tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
            self.saturationDeltaFactor = 1.85;
            break;
            
        case LolayBlurryModalSeguePresetExtraLight:
            self.tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
            self.saturationDeltaFactor = 1.85;
            break;
            
        case LolayBlurryModalSeguePresetDark:
            self.tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
            self.saturationDeltaFactor = 1.85;
            break;
            
        default:
            break;
    }
}

-(UIImageOrientation) imageOrientationFromInterfaceOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            return UIImageOrientationDown;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            return UIImageOrientationRight;
            break;
        case UIInterfaceOrientationLandscapeRight:
            return UIImageOrientationLeft;
            break;
        default:
            return UIImageOrientationUp;
    }
}

- (void)perform {
    UIViewController *sourceController = self.sourceViewController;
    UIViewController *destinationController = self.destinationViewController;
    
    CGRect windowBounds = sourceController.view.window.bounds;
    
    // Normalize based on the orientation
    CGRect nomalizedWindowBounds = [sourceController.view convertRect:windowBounds fromView:nil];
    
    UIGraphicsBeginImageContextWithOptions(windowBounds.size, YES, 0.0);
    [sourceController.view.window drawViewHierarchyInRect:windowBounds afterScreenUpdates:YES];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    snapshot = [snapshot applyBlurWithRadius:self.blurRadius tintColor:self.tintColor saturationDeltaFactor:self.saturationDeltaFactor maskImage:nil];
    
    UIImageOrientation imageOrientation = [self imageOrientationFromInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    snapshot = [UIImage imageWithCGImage:snapshot.CGImage scale:1.0 orientation:imageOrientation];
    
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:snapshot];
    //backgroundImageView.frame = nomalizedWindowBounds;
    
    // we want to stick the image to the bottom of the view. this way we just need to adjust widht/height
    backgroundImageView.contentMode = UIViewContentModeBottom;
    
    CGRect frame = CGRectMake(0, 0, nomalizedWindowBounds.size.width, nomalizedWindowBounds.size.height);
    
    if (destinationController.modalTransitionStyle == UIModalTransitionStyleCoverVertical) {
        frame.size.height = 0;
    }
    
    backgroundImageView.frame = frame;
    
    
    destinationController.view.clipsToBounds = YES;
    
    [destinationController.view addSubview:backgroundImageView];
    [destinationController.view sendSubviewToBack:backgroundImageView];

    [sourceController presentViewController:destinationController animated:YES completion:nil];
    
    [destinationController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
   
        [UIView animateWithDuration:[context transitionDuration] animations:^{
            backgroundImageView.frame = CGRectMake(0, 0, nomalizedWindowBounds.size.width, nomalizedWindowBounds.size.height);
        }];
        
    } completion:nil];
    
}

@end

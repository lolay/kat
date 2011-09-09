//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LolayPairField;

@protocol LolayPairFieldDelegate <NSObject>

@optional

- (UIView*) pairFieldSuperviewForSheet:(LolayPairField*) pairField;
- (void) pairFieldSelectedKeyChanged:(LolayPairField*) pairField;
- (void) pairFieldSheetWillShow:(LolayPairField*) pairField;
- (void) pairFieldSheetDidShow:(LolayPairField*) pairField;
- (void) pairFieldSheetWillHide:(LolayPairField*) pairField;
- (void) pairFieldSheetDidHide:(LolayPairField*) pairField;

@end

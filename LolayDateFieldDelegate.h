//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LolayDateField;

@protocol LolayDateFieldDelegate <NSObject>

@optional

- (UIView*) dateFieldSuperviewForSheet:(LolayDateField*) dateField;
- (void) dateFieldValueChanged:(LolayDateField*) dateField;
- (void) dateFieldSheetWillShow:(LolayDateField*) dateField;
- (void) dateFieldSheetDidShow:(LolayDateField*) dateField;
- (void) dateFieldSheetWillHide:(LolayDateField*) dateField;
- (void) dateFieldSheetDidHide:(LolayDateField*) dateField;

@end

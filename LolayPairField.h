//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LolayPairFieldDelegate;

@interface LolayPairField : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) IBOutlet UIButton* button;
@property (nonatomic, retain) IBOutlet UIPickerView* picker;
@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic, retain) IBOutlet UIView* sheet;
@property (nonatomic, assign) id<LolayPairFieldDelegate> delegate;
@property (nonatomic, retain) NSString* selectedKey;
@property (nonatomic, retain) NSString* selectedValue;

// Public Actions
// Pairs of NSArray of LolayStringPair
+ (LolayPairField*) pairFieldWithPairs:(NSArray*) pairs;
+ (LolayPairField*) pairFieldWithPairsFile:(NSString*) path;
+ (LolayPairField*) pairFieldWithPairsFile:(NSString*) path localized:(BOOL) localized;
- (void) hideSheet;
- (void) showSheet;

// Private Actions for Interface Builder
- (IBAction) buttonPressed:(id) sender;
- (IBAction) donePressed:(id) sender;

@end

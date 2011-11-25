//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LolayPairFieldDelegate;

@interface LolayPairField : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton* button;
@property (nonatomic, strong) IBOutlet UIPickerView* picker;
@property (nonatomic, strong) IBOutlet UIToolbar* toolbar;
@property (nonatomic, strong) IBOutlet UIView* sheet;
@property (nonatomic, unsafe_unretained) id<LolayPairFieldDelegate> delegate;
@property (nonatomic, strong) NSString* selectedKey;
@property (nonatomic, strong) NSString* selectedValue;

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

//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LolayDateFieldDelegate;

@interface LolayDateField : UIView

@property (nonatomic, strong) IBOutlet UIButton* button;
@property (nonatomic, strong) IBOutlet UIDatePicker* picker;
@property (nonatomic, strong) IBOutlet UIToolbar* toolbar;
@property (nonatomic, strong) IBOutlet UIView* sheet;
@property (nonatomic, unsafe_unretained) id<LolayDateFieldDelegate> delegate;
@property (nonatomic, strong) NSDateFormatter* dateFormatter;
@property (nonatomic, strong) NSDate* date;

// Public Actions
+ (LolayDateField*) dateField;
- (void) hideSheet;
- (void) showSheet;


// Private Actions for Interface Builder
- (IBAction) buttonPressed:(id) sender;
- (IBAction) dateChanged:(id) sender;
- (IBAction) donePressed:(id) sender;

@end

//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LolayDateFieldDelegate;

@interface LolayDateField : UIView

@property (nonatomic, retain) IBOutlet UIButton* button;
@property (nonatomic, retain) IBOutlet UIDatePicker* picker;
@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic, retain) IBOutlet UIView* sheet;
@property (nonatomic, assign) id<LolayDateFieldDelegate> delegate;
@property (nonatomic, retain) NSDateFormatter* dateFormatter;
@property (nonatomic, retain) NSDate* date;

// Public Actions
+ (LolayDateField*) dateField;
- (void) hideSheet;
- (void) showSheet;


// Private Actions for Interface Builder
- (IBAction) buttonPressed:(id) sender;
- (IBAction) dateChanged:(id) sender;
- (IBAction) donePressed:(id) sender;

@end

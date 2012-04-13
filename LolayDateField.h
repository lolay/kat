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

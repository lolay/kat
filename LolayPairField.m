//
//  Copyright 2012 Lolay, Inc. All rights reserved.
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

#import "LolayPairField.h"
#import "LolayPairFieldDelegate.h"
#import "LolayStringPair.h"

@interface LolayPairField ()

@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) NSArray* pairs;

@end

@implementation LolayPairField

@synthesize button = button_;
@synthesize picker = picker_;
@synthesize toolbar = toolbar_;
@synthesize sheet = sheet_;
@synthesize delegate = delegate_;
@dynamic selectedKey;
@dynamic selectedValue;
@synthesize selectedRow = selectedRow_;
@synthesize pairs = pairs_;

#pragma mark - Lifecycle

+ (LolayPairField*) pairField {
	NSArray* items = [[NSBundle mainBundle] loadNibNamed:@"LolayPairField" owner:self options:nil];
	for (NSObject* item in items) {
		if ([item isKindOfClass:[LolayPairField class]]) {
			return (LolayPairField*) item;
		}
	}
	return nil;
}

+ (LolayPairField*) pairFieldWithPairs:(NSArray*) pairs {
	LolayPairField* field = [LolayPairField pairField];
	field.pairs = pairs;
	return field;
}

+ (LolayPairField*) pairFieldWithPairsFile:(NSString*) path {
	NSArray* pairs = [LolayStringPair arrayWithContentsOfFile:path];
	if (pairs) {
		return [LolayPairField pairFieldWithPairs:pairs];
	} else {
		return nil;
	}
}

+ (LolayPairField*) pairFieldWithPairsFile:(NSString*) path localized:(BOOL) localized {
	NSArray* pairs = [LolayStringPair arrayWithContentsOfFile:path localized:localized];
	if (pairs) {
		return [LolayPairField pairFieldWithPairs:pairs];
	} else {
		return nil;
	}
}


- (void) handleTitle {
	if (self.pairs) {
		if (self.selectedRow >= 0 && self.selectedRow < self.pairs.count) {
			[self.button setTitle:self.selectedValue forState:UIControlStateNormal];
		}
	}
}

- (void) handlePicker {
	if (self.pairs) {
		if (self.selectedRow >= 0 && self.selectedRow < self.pairs.count) {
			[self.picker selectRow:self.selectedRow inComponent:0 animated:YES];
		}
	}
}

- (NSString*) selectedKey {
	if (self.pairs) {
		if (self.selectedRow >= 0 && self.selectedRow < self.pairs.count) {
			return ((LolayStringPair*)[self.pairs objectAtIndex:self.selectedRow]).key;
		}
	}
	return nil;
}

- (void) setSelectedKey:(NSString*) selectedKey {
	if (selectedKey == nil) {
		DLog(@"Selected Key is nil, so setting to 0)");
		self.selectedRow = 0;
	} else {
		NSInteger row = 0;
		BOOL found = NO;
		for (LolayStringPair* pair in self.pairs) {
			if ([pair.key isEqualToString:selectedKey]) {
				self.selectedRow = row;
				found = YES;
				break;
			}
			row++;
		}
		if (! found) {
			self.selectedRow = 0;
		}
	}
	
	[self handlePicker];
	[self handleTitle];
}

- (NSString*) selectedValue {
	if (self.pairs) {
		if (self.selectedRow >= 0 && self.selectedRow < self.pairs.count) {
			return ((LolayStringPair*)[self.pairs objectAtIndex:self.selectedRow]).value;
		}
	}
	return nil;
}

- (void) setSelectedValue:(NSString*) selectedValue {
	if (selectedValue == nil) {
		DLog(@"Selected Value is nil, so setting to 0)");
		self.selectedRow = 0;
	} else {
		NSInteger row = 0;
		BOOL found = NO;
		for (LolayStringPair* pair in self.pairs) {
			if ([pair.value isEqualToString:selectedValue]) {
				self.selectedRow = row;
				found = YES;
				break;
			}
			row++;
		}
		if (! found) {
			self.selectedRow = 0;
		}
	}
	[self handlePicker];
	[self handleTitle];
}

#pragma mark - LolayPairFieldDelegate

- (UIView*) superviewForSheet {
	UIView* view = nil;
	if (self.delegate && [self.delegate respondsToSelector:@selector(pairFieldSuperviewForSheet:)]) {
		view = [self.delegate pairFieldSuperviewForSheet:self];
	}
	return view;
}

- (void) valueChanged {
	DLog(@"enter");
	if (self.delegate && [self.delegate respondsToSelector:@selector(pairFieldSelectedKeyChanged:)]) {
		[self.delegate pairFieldSelectedKeyChanged:self];
	}
}

- (void) sheetWillShow {
	DLog(@"enter");
	if (self.delegate && [self.delegate respondsToSelector:@selector(pairFieldSheetWillShow:)]) {
		[self.delegate pairFieldSheetWillShow:self];
	}
}

- (void) sheetDidShow {
	DLog(@"enter");
	if (self.delegate && [self.delegate respondsToSelector:@selector(pairFieldSheetDidShow:)]) {
		[self.delegate pairFieldSheetDidShow:self];
	}
}

- (void) sheetWillHide {
	DLog(@"enter");
	if (self.delegate && [self.delegate respondsToSelector:@selector(pairFieldSheetWillHide:)]) {
		[self.delegate pairFieldSheetWillHide:self];
	}
}

- (void) sheetDidHide {
	DLog(@"enter");
	if (self.delegate && [self.delegate respondsToSelector:@selector(pairFieldSheetDidHide:)]) {
		[self.delegate pairFieldSheetDidHide:self];
	}
}

#pragma mark - Actions

- (void) hideSheet {
	DLog(@"enter");
	if (self.sheet.superview) {
		self.button.highlighted = NO;
		[self sheetWillHide];
		
		CGRect endFrame = self.sheet.frame;
		endFrame.origin.y += self.sheet.frame.size.height;
		
		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn animations:^{
			self.sheet.frame = endFrame;
		} completion:^(BOOL finished) {
			if (finished) {
				[self sheetDidHide];
			}
			[self.sheet removeFromSuperview];
		}];
	} else {
		DLog(@"Sheet has no superview, so nothing to hide");
	}
}

- (void) showSheet {
	DLog(@"enter");
	DLog(@"enter");
	UIView* view = [self superviewForSheet];
	if (view == nil) {
		DLog(@"No superview for sheet, so getting window");
		view = [UIApplication sharedApplication].keyWindow;
	}
	
	if (view) {
		if (self.sheet.superview == nil) {
			self.button.highlighted = YES;
			[self sheetWillShow];
			
			CGRect startFrame = self.sheet.frame;
			startFrame.size.width = view.bounds.size.width;
			startFrame.origin.y = view.bounds.size.height;
			self.sheet.frame = startFrame;
			
			[view addSubview:self.sheet];
			
			CGRect endFrame = startFrame;
			endFrame.origin.y -= self.sheet.frame.size.height;
			
			[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn animations:^{
				self.sheet.frame = endFrame;
			} completion:^(BOOL finished) {
				if (finished) {
					[self sheetDidShow];
				}
			}];
		}
	}
}

- (IBAction) buttonPressed:(id) sender {
	DLog(@"enter");
	[self showSheet];
}

- (IBAction) donePressed:(id) sender {
	DLog(@"enter");
	[self hideSheet];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView*) pickerView {
	return 1;
}

- (NSInteger) pickerView:(UIPickerView*) pickerView numberOfRowsInComponent:(NSInteger) component {
	return self.pairs.count;
}

#pragma mark - UIPickerViewDelegate
- (NSString*) pickerView:(UIPickerView*) pickerView titleForRow:(NSInteger) row forComponent:(NSInteger) component {
	if (self.pairs) {
		if (row >= 0 && row < self.pairs.count) {
			return ((LolayStringPair*)[self.pairs objectAtIndex:row]).value;
		}
	}
	return nil;
}

- (void) pickerView:(UIPickerView*) pickerView didSelectRow:(NSInteger) row inComponent:(NSInteger) component {
	DLog(@"enter row=%i", row);
	self.selectedRow = row;
	[self handleTitle];
	[self valueChanged];
}


@end

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


@protocol LolaySearchControllerDelegate;

@interface LolaySearchController : NSObject<UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIViewController* contentsController ;
@property (nonatomic, strong) NSString *viewNibName;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, weak) IBOutlet id<LolaySearchControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isInNavigationBar;
- (NSBundle *)bundle;

-(void) hideKeyboard;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
@end


@protocol LolaySearchControllerDelegate <NSObject>


@end
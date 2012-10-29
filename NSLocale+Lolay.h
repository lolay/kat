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

#import <Foundation/Foundation.h>

@interface NSLocale (Lolay)

- (NSString*) language;
- (NSString*) country;
- (NSString*) variant;

+ (NSString*) languageForLocale:(NSLocale*) locale;
+ (NSString*) countryForLocale:(NSLocale*) locale;
+ (NSString*) variantForLocale:(NSLocale*) locale;

+ (NSString*) languageForLocaleIdentifier:(NSString*) localeIdentifier;
+ (NSString*) countryForLocaleIdentifier:(NSString*) localeIdentifier;
+ (NSString*) variantForLocaleIdentifier:(NSString*) localeIdentifier;

+ (NSString*) preferredLanguage;

@end

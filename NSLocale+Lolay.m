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

#import "NSLocale+Lolay.h"

@implementation NSLocale (Lolay)

- (NSString*) language {
	return [self objectForKey:NSLocaleLanguageCode];
}

- (NSString*) country {
	return [self objectForKey:NSLocaleCountryCode];
}

- (NSString*) variant {
	return [self objectForKey:NSLocaleVariantCode];
}

+ (NSString*) languageForLocale:(NSLocale*) locale {
	return [locale language];
}

+ (NSString*) countryForLocale:(NSLocale*) locale {
	return [locale country];
}

+ (NSString*) variantForLocale:(NSLocale*) locale {
	return [locale variant];
}

+ (NSString*) componentForLocaleIdentifier:(NSString*) localeIdentifier index:(NSInteger) index {
	if (localeIdentifier == nil) {
		return nil;
	}
	
	NSArray* components = [localeIdentifier componentsSeparatedByString:@"_"];
	if (components.count <= index) {
		return nil;
	}
	
	return [components objectAtIndex:index];
}

+ (NSString*) languageForLocaleIdentifier:(NSString*) localeIdentifier {
	return [NSLocale componentForLocaleIdentifier:localeIdentifier index:0];
}

+ (NSString*) countryForLocaleIdentifier:(NSString*) localeIdentifier {
	return [NSLocale componentForLocaleIdentifier:localeIdentifier index:1];
}

+ (NSString*) variantForLocaleIdentifier:(NSString*) localeIdentifier {
	return [NSLocale componentForLocaleIdentifier:localeIdentifier index:2];
}

+ (NSString*) preferredLanguage {
	return [[NSLocale preferredLanguages] objectAtIndex:0];
}

@end

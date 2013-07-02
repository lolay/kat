//
//  Copyright 2013 Lolay, Inc.
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
#import "NSBundle+Lolay.h"

@implementation NSBundle (Lolay)

- (NSURL*) URLForResourceFileName:(NSString*) fileName {
	NSArray* components = [fileName componentsSeparatedByString:@"."];
	if (components.count < 2) {
		return nil;
	}
	
	NSString* extension = [components lastObject];
	NSString* name = [fileName substringToIndex:fileName.length - extension.length - 1];
	return [self URLForResource:name withExtension:extension];
}

- (NSString*) pathForResourceFileName:(NSString*) fileName {
	NSArray* components = [fileName componentsSeparatedByString:@"."];
	if (components.count < 2) {
		return nil;
	}
	
	NSString* extension = [components lastObject];
	NSString* name = [fileName substringToIndex:fileName.length - extension.length - 1];
	return [self pathForResource:name ofType:extension];
}

@end

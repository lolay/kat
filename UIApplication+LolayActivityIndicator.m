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

#import "UIApplication+LolayActivityIndicator.h"
#import <objc/runtime.h>
#import "LolayCounter.h"
#import "LolayKatGlobals.h"

@implementation UIApplication (LolayActivityIndicator)

#pragma mark - General

static char activityDictionaryKey;

- (NSMutableDictionary*) activityDictionary {
	NSMutableDictionary* dictionary = (NSMutableDictionary*) objc_getAssociatedObject(self, &activityDictionaryKey);
	if (dictionary == nil) {
		dictionary = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(self, &activityDictionaryKey, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return dictionary;
}

- (void) handleIndicator {
	NSInteger total = 0;
	for (NSString* name in [[self activityDictionary] allKeys]) {
		LolayCounter* counter = [[self activityDictionary] objectForKey:name];
		total = total + counter.integerValue;
	}
	if (total > 0) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	} else {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
}

#pragma mark - Activity For Name

- (void) presentActivityForName:(NSString*) name {
    DLog(@"enter name=%@", name);
	NSMutableDictionary* dictionary = [self activityDictionary];
	LolayCounter* counter = [dictionary objectForKey:name];
	if (counter == nil || [counter isKindOfClass:[NSNull class]]) {
		[dictionary setObject:[LolayCounter counterWithInteger:1] forKey:name];
	} else {
		[counter increment];
	}
	[self handleIndicator];
}

- (void) hideActivityForName:(NSString*) name {
    DLog(@"enter name=%@", name);
	NSMutableDictionary* dictionary = [self activityDictionary];
	LolayCounter* counter = [dictionary objectForKey:name];
	if (counter == nil || [counter isKindOfClass:[NSNull class]]) {
		// Do nothing
		
	} else {
		[counter decrement];
	}
	[self handleIndicator];
}

- (void) hideAllActivityForName:(NSString*) name {
    DLog(@"enter name=%@", name);
	NSMutableDictionary* dictionary = [self activityDictionary];
	[dictionary removeObjectForKey:name];
	LolayCounter* counter = [dictionary objectForKey:name];
	if (counter == nil || [counter isKindOfClass:[NSNull class]]) {
		// Do nothing
		
	} else {
		[counter reset];
	}
	[self handleIndicator];
}

+ (void) presentActivityForName:(NSString*) name {
	[[UIApplication sharedApplication] presentActivityForName:name];
}

+ (void) hideActivityForName:(NSString*) name {
	[[UIApplication sharedApplication] hideActivityForName:name];
}

+ (void) hideAllActivityForName:(NSString*) name {
	[[UIApplication sharedApplication] hideAllActivityForName:name];
}

#pragma mark - Activity For Class

- (void) presentActivityForClass:(Class) clazz {
	[self presentActivityForName:NSStringFromClass(clazz)];
}

- (void) hideActivityForClass:(Class) clazz {
	[self hideActivityForName:NSStringFromClass(clazz)];
}

- (void) hideAllActivityForClass:(Class) clazz {
	[self hideAllActivityForName:NSStringFromClass(clazz)];
}

+ (void) presentActivityForClass:(Class) clazz {
	[[UIApplication sharedApplication] presentActivityForClass:clazz];
}

+ (void) hideActivityForClass:(Class) clazz {
	[[UIApplication sharedApplication] hideActivityForClass:clazz];
}

+ (void) hideAllActivityForClass:(Class) clazz {
	[[UIApplication sharedApplication] hideAllActivityForClass:clazz];
}

#pragma mark - Activity For Object

NSString* applicationLolayActivityIndicatorNameForObject(id object) {
    NSString* name = [NSString stringWithFormat:@"%@:%p", NSStringFromClass([object class]), object];
    return name;
}

- (void) presentActivityForObject:(id) object {
    [self presentActivityForName:applicationLolayActivityIndicatorNameForObject(object)];
}

- (void) hideActivityForObject:(id) object {
	[self hideActivityForName:applicationLolayActivityIndicatorNameForObject(object)];
}

- (void) hideAllActivityForObject:(id) object {
	[self hideAllActivityForName:applicationLolayActivityIndicatorNameForObject(object)];
}

+ (void) presentActivityForObject:(id) object {
	[[UIApplication sharedApplication] presentActivityForObject:object];
}

+ (void) hideActivityForObject:(id) object {
	[[UIApplication sharedApplication] hideActivityForObject:object];
}

+ (void) hideAllActivityForObject:(id) object {
	[[UIApplication sharedApplication] hideAllActivityForObject:object];
}

@end

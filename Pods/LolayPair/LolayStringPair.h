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

@interface LolayStringPair : NSObject <NSCoding>

@property (nonatomic, strong, readonly) NSString* key;
@property (nonatomic, strong, readonly) NSString* value;

+ (NSArray*) arrayWithContentsOfFile:(NSString*) path;
+ (NSArray*) arrayWithContentsOfFile:(NSString*) path localized:(BOOL) localized;

+ (NSInteger) indexForValue:(NSString*) inValue pairs:(NSArray*) pairs;
+ (NSInteger) indexForKey:(NSString*) inKey pairs:(NSArray*) pairs;
+ (NSString*) keyForValue:(NSString*) inValue pairs:(NSArray*) pairs;
+ (NSString*) valueForKey:(NSString*) inKey pairs:(NSArray*) pairs;
+ (LolayStringPair*) pairForValue:(NSString*) inValue pairs:(NSArray*) pairs;
+ (LolayStringPair*) pairForKey:(NSString*) inKey pairs:(NSArray*) pairs;

- (id) initWithKey:(NSString*) inKey value:(NSString*) inValue;
- (id) initWithKey:(NSString*) inKey value:(NSString*) inValue localized:(BOOL) localized;
+ (LolayStringPair*) pairWithKey:(NSString*) inKey value:(NSString*) inValue;
+ (LolayStringPair*) pairWithKey:(NSString*) inKey value:(NSString*) inValue localized:(BOOL) localized;

@end
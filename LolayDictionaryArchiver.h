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

#import <Foundation/Foundation.h>

@interface LolayDictionaryArchiver : NSCoder

+ (NSDictionary*) dictionaryWithObject:(id) obj;

- (BOOL) allowsKeyedCoding;

- (void) encodeObject:(id) objv forKey:(NSString*) key;
- (void) encodeConditionalObject:(id) objv forKey:(NSString*) key;
- (void) encodeBool:(BOOL) boolv forKey:(NSString*) key;
- (void) encodeInt:(int) intv forKey:(NSString*) key;	// native int
- (void) encodeInt32:(int32_t) intv forKey:(NSString*) key;
- (void) encodeInt64:(int64_t) intv forKey:(NSString*) key;
- (void) encodeFloat:(float) realv forKey:(NSString*) key;
- (void) encodeDouble:(double) realv forKey:(NSString*) key;
- (void) encodeBytes:(const uint8_t*) bytesp length:(NSUInteger) lenv forKey:(NSString*) key;
@end

//
//  LolayDictionaryUnarchiver.h
//  MyLifePhone
//
//  Created by Feng Wu on 12/17/11.
//  Copyright (c) 2011 eHarmony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LolayDictionaryUnarchiver : NSCoder
+ (id)unarchiveObjectWithDictionary:(NSDictionary*) dictionary;
- (BOOL)containsValueForKey:(NSString *)key;

- (id)decodeObjectForKey:(NSString *)key;
- (BOOL)decodeBoolForKey:(NSString *)key;
- (int)decodeIntForKey:(NSString *)key;
- (int32_t)decodeInt32ForKey:(NSString *)key;
- (int64_t)decodeInt64ForKey:(NSString *)key;
- (float)decodeFloatForKey:(NSString *)key;
- (double)decodeDoubleForKey:(NSString *)key;
- (const uint8_t *)decodeBytesForKey:(NSString *)key returnedLength:(NSUInteger *)lengthp;
@end

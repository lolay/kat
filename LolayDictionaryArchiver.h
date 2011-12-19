//
//  LolayDictionaryArchiver.h
//  MyLifePhone
//
//  Created by Feng Wu on 12/16/11.
//  Copyright (c) 2011 eHarmony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LolayDictionaryArchiver : NSCoder

+ (NSDictionary*)archiveRootObject:(id)obj;

- (BOOL)allowsKeyedCoding;

- (void)encodeObject:(id)objv forKey:(NSString *)key;
- (void)encodeConditionalObject:(id)objv forKey:(NSString *)key;
- (void)encodeBool:(BOOL)boolv forKey:(NSString *)key;
- (void)encodeInt:(int)intv forKey:(NSString *)key;	// native int
- (void)encodeInt32:(int32_t)intv forKey:(NSString *)key;
- (void)encodeInt64:(int64_t)intv forKey:(NSString *)key;
- (void)encodeFloat:(float)realv forKey:(NSString *)key;
- (void)encodeDouble:(double)realv forKey:(NSString *)key;
- (void)encodeBytes:(const uint8_t *)bytesp length:(NSUInteger)lenv forKey:(NSString *)key;
@end

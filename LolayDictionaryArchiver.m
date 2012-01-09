//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import "LolayDictionaryArchiver.h"

#define LolayDictionaryArchiverVersion @"1"

@interface LolayDictionaryArchiver()

@property (nonatomic, assign, readwrite) NSMutableDictionary* archive;

- (Class) encodingClassFor: (id) obj;

@end

@implementation LolayDictionaryArchiver

@synthesize archive = archive_;

-(id) init {
    self = [super init];
    if (self) {
        self.archive = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (NSDictionary*)dictionaryWithObject:(id)obj {
    LolayDictionaryArchiver* archiver = [[LolayDictionaryArchiver alloc] init];
    [archiver.archive setObject:NSStringFromClass([archiver encodingClassFor:obj]) forKey:@"__class"]; 
    [archiver.archive setObject:LolayDictionaryArchiverVersion forKey:@"__version"];
    [obj encodeWithCoder:archiver];

    return archiver.archive;
}

- (Class) encodingClassFor: (id) obj {
    Class encodingClass;
    if (encodingClass = [obj classForKeyedArchiver])
    	return encodingClass;
    if (encodingClass = [obj classForCoder]) {
        return encodingClass;
    }; 
    return [obj class];
}

- (BOOL)allowsKeyedCoding {
    return YES;
}

- (void)encodeObject:(id)objv forKey:(NSString *)key {
    if (!objv) {
        [self.archive setObject:[NSNull null] forKey:key];
        return;
    }
    if (![objv isKindOfClass:[NSString class]]
        && ![objv isKindOfClass:[NSNumber class]]
        && ![objv isKindOfClass:[NSDate class]]
        && ![objv isKindOfClass:[NSData class]]
        && [objv conformsToProtocol:@protocol(NSCoding)]) {
        DLog(@"object at key %@ conforms to NSCoding protocol and is not NSString, NSNumber, NSDate, or NSData, so archive it with LolayDictionaryArchiver ", key);
        [self.archive setObject:[LolayDictionaryArchiver dictionaryWithObject:objv] forKey:key];
    } else {
        DLog(@"object at key %@ does not confrom to NSCoding protocol, or is one of NSString, NSNumber, NSDate, NSData, so archive it as is", key);
        [self.archive setObject: objv forKey:key];
    }
}

/**
 Does not support conditional object yet.  This simply calls [self encodeObject:objv]
 */
- (void)encodeConditionalObject:(id)objv forKey:(NSString *)key{
    [self encodeObject:objv];
}

- (void)encodeBool:(BOOL)boolv forKey:(NSString *)key {
    [self.archive setObject:[NSNumber numberWithBool:boolv] forKey:key];
}

// native int
- (void)encodeInt:(int)intv forKey:(NSString *)key {
    [self.archive setObject:[NSNumber numberWithInt:intv] forKey:key];
}

- (void)encodeInt32:(int32_t)intv forKey:(NSString *)key {
    [self.archive setObject:[NSNumber numberWithInt:intv] forKey:key];
}
- (void)encodeInt64:(int64_t)intv forKey:(NSString *)key{
    [self.archive setObject:[NSNumber numberWithLongLong:intv] forKey:key];
    
}
- (void)encodeFloat:(float)realv forKey:(NSString *)key{
    [self.archive setObject:[NSNumber numberWithFloat:realv] forKey:key];
    
}
- (void)encodeDouble:(double)realv forKey:(NSString *)key{
    [self.archive setObject:[NSNumber numberWithDouble:realv] forKey:key];
    
}
- (void)encodeBytes:(const uint8_t *)bytesp length:(NSUInteger)lenv forKey:(NSString *)key{
    NSData * data = [NSData dataWithBytes: bytesp length: lenv];
    [self.archive setObject:data forKey:key];
}

@end

//
//  LolayDictionaryArchiver.m
//  MyLifePhone
//
//  Created by Feng Wu on 12/16/11.
//  Copyright (c) 2011 eHarmony. All rights reserved.
//

#import "LolayDictionaryArchiver.h"

@interface LolayDictionaryArchiver()

@property (nonatomic, assign, readwrite) NSMutableDictionary* archive;
@property (nonatomic, assign, readwrite) NSMutableDictionary* metadata;

- (void)setDictionaryArchived:(BOOL) flag forKey:(NSString *)key;
- (void)setClass:(Class) class forKey:(NSString *) key;
- (Class) encodingClassFor: (id) obj;

@end

@implementation LolayDictionaryArchiver

@synthesize archive = archive_;
@synthesize metadata = metadata_;

-(id) init {
    self = [super init];
    if (self) {
        archive_ = [NSMutableDictionary dictionary];
        metadata_ = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (NSDictionary*)archiveRootObject:(id)obj {
    LolayDictionaryArchiver* archiver = [[LolayDictionaryArchiver alloc] init];
    [obj encodeWithCoder:archiver];
    [archiver setDictionaryArchived:YES forKey:@"_archive_root"];
    [archiver setClass:[archiver encodingClassFor:obj] forKey:@"_archive_root"];
    NSDictionary* combined = [NSDictionary dictionaryWithObjectsAndKeys:archiver.archive, @"archive", archiver.metadata, @"metadata", nil];
    return combined;
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

- (void)setDictionaryArchived:(BOOL)flag forKey:(NSString *) key {
    [self.metadata setObject:[NSNumber numberWithBool:flag] forKey:[key stringByAppendingString:@".dictionaryArchived"]];        
}

/*
 * Saves class name
 */
- (void)setClass:(Class) class forKey:(NSString *) key {
    [self.metadata setObject:NSStringFromClass(class) forKey:[key stringByAppendingString:@".class"]];    
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
        && ![objv isKindOfClass:[NSDate class]]
        && ![objv isKindOfClass:[NSData class]]
        && [objv conformsToProtocol:@protocol(NSCoding)]) {
        NSLog(@"object at key %@ conforms to NSCoding protocol and is not NSString, NSDate, or NSData, so archive it with LolayDictionaryArchiver ", key);
        [self.archive setObject:[LolayDictionaryArchiver archiveRootObject:objv] forKey:key];
        [self setDictionaryArchived: YES forKey:key];
    } else {
        NSLog(@"object at key %@ does not confrom to NSCoding protocol, or is one of NSString, NSDate, NSData, so archive it as is", key);
        [self.archive setObject: objv forKey:key];
        [self setDictionaryArchived: NO forKey:key];
    }
    Class encodingClass = [self encodingClassFor:objv];
    NSLog(@"encodingClass for key %@ = %@", key, encodingClass);
    [self setClass:encodingClass forKey:key];
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

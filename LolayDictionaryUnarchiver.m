//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import "LolayDictionaryUnarchiver.h"

@interface LolayDictionaryUnarchiver ()
@property (nonatomic, assign, readwrite) NSDictionary* archive;
@property (nonatomic, assign, readwrite) NSDictionary* metadata;
@end

@implementation LolayDictionaryUnarchiver

@synthesize archive = archive_;
@synthesize metadata = metadata_;

-(id) initWithDictionary:(NSDictionary*) combined {
    self = [super init];
    if (self) {
        archive_ = [NSMutableDictionary dictionaryWithDictionary:[combined objectForKey:@"archive"]];
        metadata_ = [NSMutableDictionary dictionaryWithDictionary:[combined objectForKey:@"metadata"]];
    }
    return self;
}

- (BOOL)allowsKeyedCoding {
    return YES;
}

- (Class) allocationClassFor: (Class) decodingClass {
    Class allocationClass = [decodingClass classForKeyedUnarchiver];
    if (allocationClass == nil)
        return decodingClass;
    else
        return allocationClass;
}


+ (id)unarchiveObjectWithDictionary:(NSDictionary*) combined {
    LolayDictionaryUnarchiver* unarchiver = [[LolayDictionaryUnarchiver alloc] initWithDictionary:combined];
    Class decodingClass = NSClassFromString([unarchiver.metadata objectForKey:@"_archive_root.class"]);
    NSLog(@"decodingClass = %a", decodingClass);
    if (decodingClass == nil) {
        return nil;
    }
    id allocatedObject = [[unarchiver allocationClassFor:decodingClass] alloc];
    id initializedObject = [allocatedObject initWithCoder:unarchiver];
    id awakendObject = [initializedObject awakeAfterUsingCoder:unarchiver];
    
    if (initializedObject != awakendObject) {
        initializedObject = nil;
    }
    
    return awakendObject;
}


- (BOOL)containsValueForKey:(NSString *)key {
    return [self.archive objectForKey:key] != nil;
}

- (id)decodeObjectForKey:(NSString *)key {
    if ([[self.archive objectForKey:key] isEqual:[NSNull null]]) {
        return nil;
    }
    NSNumber* number = [self.metadata objectForKey:[key stringByAppendingString:@".dictionaryArchived"]];
    BOOL dictionaryArchived = [number boolValue];
    if (!dictionaryArchived) {
        NSLog(@"object with key %@ is not dictionary archived, return as is", key);
        return [self.archive objectForKey:key];
    }
    NSLog(@"object with key %@ is dictionary archived, unarchive it", key);
    NSDictionary* child = [self.archive objectForKey:key]; // this is a combined dictionary
    id object = [LolayDictionaryUnarchiver unarchiveObjectWithDictionary:child];
    return object;
}

- (BOOL)decodeBoolForKey:(NSString *)key {
    NSNumber* number = [self.archive objectForKey:key];
    return [number boolValue];
}

- (int)decodeIntForKey:(NSString *)key {
    NSNumber* number = [self.archive objectForKey:key];
    return [number intValue];
}

- (int32_t)decodeInt32ForKey:(NSString *)key {
    NSNumber* number = [self.archive objectForKey:key];
    return [number intValue];
}
- (int64_t)decodeInt64ForKey:(NSString *)key {
    NSNumber* number = [self.archive objectForKey:key];
    return [number longLongValue];
}
- (float)decodeFloatForKey:(NSString *)key {
    NSNumber* number = [self.archive objectForKey:key];
    return [number floatValue];
}
- (double)decodeDoubleForKey:(NSString *)key {
    NSNumber* number = [self.archive objectForKey:key];
    return [number doubleValue];
}
- (const uint8_t *)decodeBytesForKey:(NSString *)key returnedLength:(NSUInteger *)lengthp {
    NSData* data = [self.archive objectForKey:key];
    return [data bytes];
    
}

@end

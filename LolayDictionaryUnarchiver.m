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

#import "LolayDictionaryUnarchiver.h"

@interface LolayDictionaryUnarchiver ()
@property (nonatomic, strong, readwrite) NSDictionary* archive;
@end

@implementation LolayDictionaryUnarchiver

@synthesize archive = archive_;

-(id) initWithDictionary:(NSDictionary*) archive {
    self = [super init];
    if (self) {
        self.archive = archive;
    }
    return self;
}

- (BOOL) allowsKeyedCoding {
    return YES;
}

- (Class) allocationClassFor: (Class) decodingClass {
    Class allocationClass = [decodingClass classForKeyedUnarchiver];
    if (allocationClass == nil) {
        return decodingClass;
    } else {
        return allocationClass;
    }
}


+ (id) objectWithDictionary:(NSDictionary*) combined {
    LolayDictionaryUnarchiver* unarchiver = [[LolayDictionaryUnarchiver alloc] initWithDictionary:combined];
    Class decodingClass = NSClassFromString([unarchiver.archive objectForKey:@"__class"]);
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


- (BOOL) containsValueForKey:(NSString*) key {
    return [self.archive objectForKey:key] != nil;
}

- (id) decodeObjectForKey:(NSString*) key {
    if ([[self.archive objectForKey:key] isEqual:[NSNull null]]) {
        return nil;
    }
    
    id object = [self.archive objectForKey:key];
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dictionary = (NSDictionary*) object;
        NSString* className = [dictionary objectForKey:@"__class"];
        if (className) {
            // we have a type
            DLog(@"object with key %@ is dictionary archived with type %@, unarchived it", key, className);
            id unarchived = [LolayDictionaryUnarchiver objectWithDictionary:object];
            return unarchived;
        } else {
            DLog(@"object with key %@ is a regular dictionary, return as is", key);
            return object;
        }
        
    } else {
        DLog(@"object with key %@ is not a NSDictionary, return as is", key);
        return object;
    }
}

- (BOOL) decodeBoolForKey:(NSString*) key {
    NSNumber* number = [self.archive objectForKey:key];
    return [number boolValue];
}

- (int) decodeIntForKey:(NSString*) key {
    NSNumber* number = [self.archive objectForKey:key];
    return [number intValue];
}

- (int32_t) decodeInt32ForKey:(NSString*) key {
    NSNumber* number = [self.archive objectForKey:key];
    return [number intValue];
}
- (int64_t) decodeInt64ForKey:(NSString*) key {
    NSNumber* number = [self.archive objectForKey:key];
    return [number longLongValue];
}
- (float) decodeFloatForKey:(NSString*) key {
    NSNumber* number = [self.archive objectForKey:key];
    return [number floatValue];
}
- (double) decodeDoubleForKey:(NSString*) key {
    NSNumber* number = [self.archive objectForKey:key];
    return [number doubleValue];
}
- (const uint8_t*) decodeBytesForKey:(NSString*) key returnedLength:(NSUInteger*) lengthp {
    NSData* data = [self.archive objectForKey:key];
    return [data bytes];
    
}

@end

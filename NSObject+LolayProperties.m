//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//  
//  Based on http://stackoverflow.com/questions/830673/instantiating-custom-class-from-nsdictionary

#import "NSObject+LolayProperties.h"
#import "objc/runtime.h"

@implementation NSObject (LolayProperties)
- (NSArray *) allKeys {
    Class clazz = [self class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++) {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    return [NSArray arrayWithArray:propertyArray];
}
@end

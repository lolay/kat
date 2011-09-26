//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSStringFromInteger(integerValue) [NSString stringWithInteger:integerValue];

@interface NSString (LolayString)

+ (NSString*) stringWithInteger:(NSInteger) integerValue;

@end

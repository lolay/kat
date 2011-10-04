//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSStringFromInteger(integerValue) [NSString stringWithInteger:integerValue]
#define NSStringFromNSInteger(integerValue) [NSString stringWithInteger:integerValue]
#define NSStringCSVFromNSArray(arrayValue) [NSString stringCsvWithArray:arrayValue]

@interface NSString (LolayString)

+ (NSString*) stringWithInteger:(NSInteger) integerValue;
+ (NSString*) stringCsvWithArray:(NSArray*) array;

@end

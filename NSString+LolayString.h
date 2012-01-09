//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSStringFromInteger(integerValue) [NSString stringWithInteger:integerValue]
#define NSStringFromNSInteger(integerValue) [NSString stringWithInteger:integerValue]
#define NSStringCSVFromNSArray(arrayValue) [NSString stringCsvWithArray:arrayValue]
#define NSStringFromBOOL(boolValue) [NSString stringWithBOOL:boolValue]

@interface NSString (LolayString)

+ (NSString*) stringWithInteger:(NSInteger) integerValue;
+ (NSString*) stringCsvWithArray:(NSArray*) array;
+ (NSString*) stringWithBOOL:(BOOL) boolValue;

- (NSString*) trim;

@end

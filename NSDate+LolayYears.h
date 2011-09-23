//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LolayYears)

- (NSInteger) ageForCalendar:(NSCalendar*) calendar;
- (NSInteger) age;
+ (NSInteger) ageFromDate:(NSDate*) date;
+ (NSInteger) ageFromDate:(NSDate*) date calendar:(NSCalendar*) calendar;

@end

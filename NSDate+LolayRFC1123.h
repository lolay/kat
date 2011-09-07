//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LolayRFC1123)

- (NSString*) rfc1123String;
+ (NSString*) rfc1123StringFromDate:(NSDate*) date;

@end

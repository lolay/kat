//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LolayCounter : NSObject

@property (nonatomic, assign, readonly) NSInteger integerValue;

+ (LolayCounter*) counter;
+ (LolayCounter*) counterWithInteger:(NSInteger) integer;

- (void) increment;
- (void) decrement;
- (void) reset;

@end

//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import "NSString+LolayString.h"

@implementation NSString (LolayString)

+ (NSString*) stringWithInteger:(NSInteger) integerValue {
	return [NSString stringWithFormat:@"%i", integerValue];
}

@end

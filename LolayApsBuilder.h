//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LolayApsBuilder : NSObject

+ (UIAlertView*) handleAPS:(NSDictionary*) aps title:(NSString*) title;
+ (UIAlertView*) handleAPS:(NSDictionary*) aps titleKey:(NSString*) titleKey;
+ (UIAlertView*) handleAPS:(NSDictionary*) aps;

@end

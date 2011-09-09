//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// See iPhone Design Aware-Winning Projects AccuTerra Memory Diagnostics

@interface LolayMemoryDiagnostics : NSObject

+ (NSInteger) systemMemoryInMB;
+ (NSInteger) systemFreeMemoryInMB;
+ (NSInteger) systemInactiveMemoryInMB;
+ (NSInteger) systemAvailableMemoryInMB;
// from 0.0 to 1.0
+ (Float32) systemPercentFree;
+ (Float32) systemPercentAvailable;
+ (BOOL) systemFreeMemoryIsAvailableInMB:(NSInteger) megabytes;

@end

//
//  Copyright 2012 Lolay, Inc. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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

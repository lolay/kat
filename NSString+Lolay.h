//
//  Copyright 2012 Lolay, Inc.
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

#define NSStringFromInteger(integerValue) [NSString stringWithInteger:integerValue]
#define NSStringFromNSInteger(integerValue) [NSString stringWithInteger:integerValue]
#define NSStringCSVFromNSArray(arrayValue) [NSString stringCsvWithArray:arrayValue]
#define NSStringFromBOOL(boolValue) [NSString stringWithBOOL:boolValue]

@interface NSString (Lolay)

+ (NSString*) stringWithInteger:(NSInteger) integerValue;
+ (NSString*) stringCsvWithArray:(NSArray*) array;
+ (NSString*) stringWithBOOL:(BOOL) boolValue;

- (NSString*) trim;

@end

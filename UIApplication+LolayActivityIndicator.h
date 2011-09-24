//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (LolayActivityIndicator)

- (void) presentActivityForName:(NSString*) name;
- (void) hideActivityForName:(NSString*) name;
- (void) hideAllActivityForName:(NSString*) name;
+ (void) presentActivityForName:(NSString*) name;
+ (void) hideActivityForName:(NSString*) name;
+ (void) hideAllActivityForName:(NSString*) name;

- (void) presentActivityForClass:(Class) clazz;
- (void) hideActivityForClass:(Class) clazz;
- (void) hideAllActivityForClass:(Class) clazz;
+ (void) presentActivityForClass:(Class) clazz;
+ (void) hideActivityForClass:(Class) clazz;
+ (void) hideAllActivityForClass:(Class) clazz;

- (void) presentActivityForObject:(id) object;
- (void) hideActivityForObject:(id) object;
- (void) hideAllActivityForObject:(id) object;
+ (void) presentActivityForObject:(id) object;
+ (void) hideActivityForObject:(id) object;
+ (void) hideAllActivityForObject:(id) object;

@end

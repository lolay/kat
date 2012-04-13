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

#import "LolayApsBuilder.h"

@implementation LolayApsBuilder

+ (id) objectForDictionary:(NSDictionary*) dictionary key:(id) key {
	id value = [dictionary objectForKey:key];
	if ([value isKindOfClass:[NSNull class]]) {
		return nil;
	}
	return value;
}

+ (UIAlertView*) handleAPS:(NSDictionary*) aps title:(NSString*) title {
	DLog(@"enter aps=%@,title=%@", aps, title);
	if (aps == nil) {
		return nil;
	}
	
	NSNumber* badge = [LolayApsBuilder objectForDictionary:aps key:@"badge"];
	if (badge) {
		DLog(@"Set the badge to %@", badge);
		[UIApplication sharedApplication].applicationIconBadgeNumber = [badge integerValue];
	} else {
		DLog(@"Unset the badge");
		[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	}
	
	NSString* action = nil;
	NSString* message = nil;
	
	id alert = [LolayApsBuilder objectForDictionary:aps key:@"alert"];
	if (alert) {
		if ([alert isKindOfClass:[NSString class]]) {
			message = alert;
		} else if ([alert isKindOfClass:[NSDictionary class]]) {
			NSString* body = [LolayApsBuilder objectForDictionary:alert key:@"body"];
			NSString* actionKey = [LolayApsBuilder objectForDictionary:alert key:@"action-loc-key"];
			NSString* key = [LolayApsBuilder objectForDictionary:alert key:@"loc-key"];
			NSArray* args = [LolayApsBuilder objectForDictionary:alert key:@"loc-args"];
			
			if (body) {
				message = body;
			} else if (key) {
				NSString* format = NSLocalizedString(key, nil);
				
				if (args) {
					// http://cocoawithlove.com/2009/05/variable-argument-lists-in-cocoa.html
					// http://stackoverflow.com/questions/8211996/fake-va-list-in-arc
					NSRange argsRange = NSMakeRange(0, args.count);
					NSMutableData* argsList = [NSMutableData dataWithLength:sizeof(id) * args.count];
					[args getObjects:(__unsafe_unretained id*)argsList.mutableBytes range:argsRange];
					message = [[NSString alloc] initWithFormat:format arguments:argsList.mutableBytes];
				} else {
					message = format;
				}
			}
			
			if (actionKey) {
				action = NSLocalizedString(actionKey, nil);
			}
		}
	}
	
	NSString* ok = NSLocalizedString(@"lolay-aps-ok", nil);
	if ([ok isEqualToString:@"lolay-aps-ok"]) {
		ok = @"Ok";
	}
	NSString* close = NSLocalizedString(@"lolay-aps-close", nil);
	if ([close isEqualToString:@"lolay-aps-close"]) {
		close = @"Close";
	}
	
	NSString* cancel = action.length > 0 ? close : ok;
	
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:action, nil];
	return alertView;
}

+ (UIAlertView*) handleAPS:(NSDictionary*) aps titleKey:(NSString*) titleKey {
	return [LolayApsBuilder handleAPS:aps title:NSLocalizedString(titleKey, nil)];
}

+ (UIAlertView*) handleAPS:(NSDictionary*) aps {
	return [LolayApsBuilder handleAPS:aps title:nil];
}

+ (NSString*) tokenFromData:(NSData*) dataToken {
	NSString* token = [dataToken description];
	token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
	token = [token uppercaseString];
	return token;
}

@end

//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
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
					char* argsList = (char*) malloc(sizeof(NSString*) * args.count);
					[args getObjects:(id*) argsList];
					message = [[[NSString alloc] initWithFormat:format arguments:argsList] autorelease];
					free(argsList);
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
	
	UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:action, nil] autorelease];
	return alertView;
}

+ (UIAlertView*) handleAPS:(NSDictionary*) aps titleKey:(NSString*) titleKey {
	return [LolayApsBuilder handleAPS:aps title:NSLocalizedString(titleKey, nil)];
}

+ (UIAlertView*) handleAPS:(NSDictionary*) aps {
	return [LolayApsBuilder handleAPS:aps title:nil];
}

@end

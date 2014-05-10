//
//  LolayPairGlobals.h
//  LolayPair
//
//  Created by Bruce Johnson on 5/9/14.
//  Copyright (c) 2014 Lolay. All rights reserved.
//

#if DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#	define NSLog(...) NSLog(__VA_ARGS__)
#else
#	define DLog(fmt, ...) {}
#	define NSLog(...) {}
#endif

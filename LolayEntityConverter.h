//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface LolayEntityConverter : NSObject<NSXMLParserDelegate>

@property (nonatomic, retain) NSMutableString* resultString;
- (NSString*)unescapeEntitiesInString:(NSString*)s;

@end


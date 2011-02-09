//
//  LolayEntityConverter.h
//  Singles
//
//  Copyright 2011 eHarmony. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LolayEntityConverter : NSObject<NSXMLParserDelegate>

@property (nonatomic, retain) NSMutableString* resultString;
- (NSString*)unescapeEntitiesInString:(NSString*)s;

@end


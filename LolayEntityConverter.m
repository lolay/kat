//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import "LolayEntityConverter.h"



@implementation LolayEntityConverter

@synthesize resultString = resultString_;

- (void) parser:(NSXMLParser*) parser foundCharacters:(NSString*) s
{
	[self.resultString appendString:s];
}

- (NSString*) unescapeEntitiesInString:(NSString*) s {
	self.resultString = [NSMutableString string];
	
    NSString* xmlStr = [NSString stringWithFormat:@"<d>%@</d>", s];
    NSData* data = [xmlStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSXMLParser* xmlParse = [[NSXMLParser alloc] initWithData:data];
    [xmlParse setDelegate:self];
    [xmlParse parse];
    return [NSString stringWithString:self.resultString];
}

@end

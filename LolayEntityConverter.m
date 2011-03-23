//
//  LolayEntityConverter.m
//  Singles
//
//  Copyright 2011 eHarmony. All rights reserved.
//

#import "LolayEntityConverter.h"



@implementation LolayEntityConverter

@synthesize resultString = resultString_;

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)s
{
	[self.resultString appendString:s];
}

- (NSString*)unescapeEntitiesInString:(NSString*)s {
	self.resultString = [NSMutableString string];
	
    NSString* xmlStr = [NSString stringWithFormat:@"<d>%@</d>", s];
    NSData* data = [xmlStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSXMLParser* xmlParse = [[[NSXMLParser alloc] initWithData:data] autorelease];
    [xmlParse setDelegate:self];
    [xmlParse parse];
    return [NSString stringWithString:self.resultString];
}

- (void)dealloc {
    self.resultString = nil;
    [super dealloc];
}

@end

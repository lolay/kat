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

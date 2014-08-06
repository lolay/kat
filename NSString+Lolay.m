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

#import "NSString+Lolay.h"

@implementation NSString (Lolay)

+ (NSString*) stringWithInteger:(NSInteger) integerValue {
	return [NSString stringWithFormat:@"%li", (long) integerValue];
}

+ (NSString*) stringCsvWithArray:(NSArray*) array {
	NSMutableString* string = [NSMutableString stringWithCapacity:32 * array.count];
	BOOL first = YES;
	for (NSObject* object in array) {
		if (first) {
			first = NO;
		} else {
			[string appendString:@","];
		}
		
		[string appendString:[object description]];
	}
	return string;
}

+ (NSString*) stringWithBOOL:(BOOL) boolValue {
	return boolValue ? @"YES" : @"NO";
}

+ (NSString*) stringWithUIImage:(UIImage*) image {
	return NSStringFromCGSize(image.size);
}

- (NSString*) trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString*) stringValue {
	return self;
}

- (NSString*) lolayFileNameString {
    NSMutableString* filename = [[NSMutableString alloc] init];
    
    NSUInteger length = self.length;
    unichar buffer[length];
    [self getCharacters:buffer range:NSMakeRange(0, length)];
    
    for (unsigned int i=0; i<self.length; i++) {
        
        unichar character = buffer[i];
        if (character == 0x2d || character == 0x2e || (character >= 0x30 && character <= 0x39) || (character >= 0x41 && character <= 0x5a) || character == 0x5f || (character >= 0x61 && character <= 0x7a)) {
            [filename appendFormat:@"%C", character];
        } else {
            [filename appendFormat:@"%X", character];
        }
    }
    
    return [NSString stringWithString:filename];
}

-(NSString *) stringByStrippingHTML {
	/*NSRange r;
	NSString *s = [self copy];
	while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
		s = [s stringByReplacingCharactersInRange:r withString:@""];
	return s;*/
	NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
	
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
	
    NSAttributedString *str =  [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
	return str.string;
}

-(BOOL)stringIsValidEmail{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end

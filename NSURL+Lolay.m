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

#import "NSURL+Lolay.h"

@implementation NSURL (Lolay)

- (NSString*) absoluteStringAsFileName {
    
    NSMutableString* filename = [[NSMutableString alloc] init];
    
    unsigned int length = self.absoluteString.length;
    unichar buffer[length];
    [self.absoluteString getCharacters:buffer range:NSMakeRange(0, length)];
    
    for (unsigned int i=0; i<self.absoluteString.length; i++) {
        
        unichar character = buffer[i];
        if (character == 0x2d || character == 0x2e || (character >= 0x30 && character <= 0x39) || (character >= 0x41 && character <= 0x5a) || character == 0x5f || (character >= 0x61 && character <= 0x7a)) {
            [filename appendFormat:@"%C", character];
        } else {
            [filename appendFormat:@"%X", character];
        }
    }
    
    return [NSString stringWithString:filename];
}

@end

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
#import "LolayStringPair.h"
#import "LolayPairGlobals.h"

@interface LolayStringPair ()

@property (nonatomic, strong, readwrite) NSString* key;
@property (nonatomic, strong, readwrite) NSString* rawValue;
@property (nonatomic, assign, readwrite) BOOL localized;

@end

@implementation LolayStringPair

@synthesize key = key_;
@dynamic value;
@synthesize rawValue = rawValue_;
@synthesize localized = localized_;

+ (NSArray*) arrayWithContentsOfFile:(NSString*) path {
	return [LolayStringPair arrayWithContentsOfFile:path localized:NO];
}

+ (NSArray*) arrayWithContentsOfFile:(NSString*) path localized:(BOOL) localized {
	DLog(@"enter path=%@", path);
	NSArray* sourcePairs = [NSArray arrayWithContentsOfFile:path];
	NSMutableArray* pairs = [[NSMutableArray alloc] initWithCapacity:sourcePairs.count];
	
	for (NSArray* sourcePair in sourcePairs) {
		LolayStringPair* pair = [[LolayStringPair alloc] initWithKey:[sourcePair objectAtIndex:0] value:[sourcePair objectAtIndex:1] localized:localized];
		[pairs addObject:pair];
	}
	
	return pairs;
}

+ (NSInteger) indexForValue:(NSString*) inValue pairs:(NSArray*) pairs {
	NSInteger i = 0;
	for (LolayStringPair* pair in pairs) {
		if ([inValue isEqualToString:pair.value]) {
			return i;
		}
		i++;
	}
	return -1;
}

+ (NSInteger) indexForKey:(NSString*) inKey pairs:(NSArray*) pairs {
	NSInteger i = 0;
	for (LolayStringPair* pair in pairs) {
		if ([inKey isEqualToString:pair.key]) {
			return i;
		}
		i++;
	}
	return -1;
}

+ (NSString*) keyForValue:(NSString*) inValue pairs:(NSArray*) pairs {
	return [self pairForValue:inValue pairs:pairs].key;
}

+ (NSString*) valueForKey:(NSString*) inKey pairs:(NSArray*) pairs {
	return [self pairForKey:inKey pairs:pairs].value;
}

+ (LolayStringPair*) pairForValue:(NSString*) inValue pairs:(NSArray*) pairs {
	for (LolayStringPair* pair in pairs) {
		if (pair.value != nil && [inValue isEqualToString:pair.value]) {
			return pair;
		}
	}
	return nil;
}

+ (LolayStringPair*) pairForKey:(NSString*) inKey pairs:(NSArray*) pairs {
	for (LolayStringPair* pair in pairs) {
		if (pair.key != nil && [inKey isEqualToString:pair.key]) {
			return pair;
		}
	}
	return nil;
}

- (id) initWithKey:(NSString*) inKey value:(NSString*) inValue {
	return [self initWithKey:inKey value:inValue localized:NO];
}

- (id) initWithKey:(NSString*) inKey value:(NSString*) inValue localized:(BOOL) localized {
	self = [super init];
	
	if (self) {
		self.key = inKey;
		self.rawValue = inValue;
		self.localized = localized;
	}
	
	return self;
}

- (id) initWithCoder:(NSCoder*) decoder {
	if (! [decoder allowsKeyedCoding]) {
		[NSException raise:@"Unsupported Archiver" format:@"Only Keyed Archivers are supported"];
	}
	
	self = [super init];
	
	if (self) {
		self.key = [decoder decodeObjectForKey:@"key"];
		self.rawValue = [decoder decodeObjectForKey:@"rawValue"];
		self.localized = [decoder decodeBoolForKey:@"localized"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*) encoder {
	if (! [encoder allowsKeyedCoding]) {
		[NSException raise:@"Unsupported Archiver" format:@"Only Keyed Archivers are supported"];
	}

	[encoder encodeObject:self.key forKey:@"key"];
	[encoder encodeObject:self.rawValue forKey:@"rawValue"];
	[encoder encodeBool:self.localized forKey:@"localized"];
}

+ (LolayStringPair*) pairWithKey:(NSString*) inKey value:(NSString*) inValue {
	return [LolayStringPair pairWithKey:inKey value:inValue localized:NO];
}

+ (LolayStringPair*) pairWithKey:(NSString*) inKey value:(NSString*) inValue localized:(BOOL) localized {
	return [[LolayStringPair alloc] initWithKey:inKey value:inValue localized:localized];
}

- (NSString*) value {
	return self.localized ? NSLocalizedString(self.rawValue, nil) : self.rawValue;
}

#pragma mark - NSObject

- (NSString*) description {
	NSMutableString* description = [NSMutableString stringWithCapacity:64];
	[description appendString:@"<LolayStringPair "];
	[description appendFormat:@"key=%@,", self.key];
	[description appendFormat:@"value=%@,", self.value];
	[description appendString:@">"];
	return description;
}

@end
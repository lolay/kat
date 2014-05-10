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
#import "LolayNamePair.h"
#import "LolayPairGlobals.h"

@interface LolayNamePair ()

@property (nonatomic, strong, readwrite) NSString* name;
@property (nonatomic, strong, readwrite) NSString* rawDetail;
@property (nonatomic, assign, readwrite) BOOL localized;

@end

@implementation LolayNamePair

@synthesize name = name_;
@dynamic detail;
@synthesize rawDetail = rawDetail_;
@synthesize localized = localized_;

+ (NSArray*) arrayWithContentsOfFile:(NSString*) path {
	return [LolayNamePair arrayWithContentsOfFile:path localized:NO];
}

+ (NSArray*) arrayWithContentsOfFile:(NSString*) path localized:(BOOL) localized {
	DLog(@"enter path=%@", path);
	NSArray* sourcePairs = [NSArray arrayWithContentsOfFile:path];
	NSMutableArray* pairs = [[NSMutableArray alloc] initWithCapacity:sourcePairs.count];
	
	for (NSArray* sourcePair in sourcePairs) {
		LolayNamePair* pair = [[LolayNamePair alloc] initWithName:[sourcePair objectAtIndex:0] detail:[sourcePair objectAtIndex:1]];
		[pairs addObject:pair];
	}
	
	return pairs;
}

- (id) initWithName:(NSString*) inName detail:(NSString*) inDetail {
	return [self initWithName:inName detail:inDetail localized:NO];
}

- (id) initWithName:(NSString*) inName detail:(NSString*) inDetail localized:(BOOL) localized {
	self = [super init];
	
	if (self) {
		self.name = inName;
		self.rawDetail = inDetail;
		self.localized = localized;
	}
	
	return self;
}

+ (LolayNamePair*) pairWithName:(NSString*) inName detail:(NSString*) inDetail {
	return [LolayNamePair pairWithName:inName detail:inDetail localized:NO];
}

+ (LolayNamePair*) pairWithName:(NSString*) inName detail:(NSString*) inDetail localized:(BOOL) localized {
	return [[LolayNamePair alloc] initWithName:inName detail:inDetail localized:localized];
}

@end
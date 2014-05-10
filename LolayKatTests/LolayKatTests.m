//
//  LolayKatTests.m
//  LolayKatTests
//
//  Created by Bruce Johnson on 5/9/14.
//  Copyright (c) 2014 Lolay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIColor+Lolay.h"

#define RED_HEX 0xFF0000

@interface LolayKatTests : XCTestCase

@property (nonatomic, readwrite, strong) UIColor *color;

@end

@implementation LolayKatTests

- (void)setUp
{
    [super setUp];
	self.color = [UIColor colorWithHex: RED_HEX];
}

- (void)tearDown
{
	self.color = nil;
    [super tearDown];
}

- (void)testHexColor
{
	XCTAssertNotNil(self.color, @"color is nil value.");
}

@end

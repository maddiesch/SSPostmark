/*!
*  SSPostmarkHeaderItemTests.m
*  SSPostmark
*
*  Created by Skylar Schipper on 7/17/14.
*    Copyright (c) 2014 OpenSky, LLC. All rights reserved.
*/

#import "TestHelpers.h"

@interface SSPostmarkHeaderItemTests : XCTestCase

@end

@implementation SSPostmarkHeaderItemTests

- (void)testJSONEncoding {
    SSPostmarkHeaderItem *headerItem = [SSPostmarkHeaderItem headerWithName:@"KEY" value:@"My Value"];
    NSDictionary *JSON = [headerItem JSONRepresentation];
    
    XCTAssertEqualObjects(JSON[@"Name"], @"KEY");
    XCTAssertEqualObjects(JSON[@"Value"], @"My Value");
}

@end

//
//  SSAttachmentTests.m
//  SSPostmark
//
//  Created by Skylar Schipper on 12/29/16.
//  Copyright © 2016 Skylar Schipper. All rights reserved.
//

@import XCTest;
@import SSPostmark;

@interface SSAttachmentTests : XCTestCase

@end

@implementation SSAttachmentTests

- (void)testInferedContentType {
    XCTAssertEqualObjects([SSAttachment inferContentTypeForFileName:@"test.png"], @"image/png");
    XCTAssertEqualObjects([SSAttachment inferContentTypeForFileName:@"test.jpeg"], @"image/jpeg");
}

@end

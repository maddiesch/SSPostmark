/*!
*  SSPostmarkAttachmentTests.m
*  SSPostmark
*
*  Created by Skylar Schipper on 10/25/13.
*    Copyright (c) 2013 Skylar Schipper. All rights reserved.
*/

#import <XCTest/XCTest.h>
#import "SSPostmarkAttachment.h"

@interface SSPostmarkAttachmentTests : XCTestCase

@property (nonatomic, strong) SSPostmarkAttachment *attachment;

@end

@implementation SSPostmarkAttachmentTests

- (void)setUp {
    [super setUp];
    
    self.attachment = [[SSPostmarkAttachment alloc] init];
}

- (void)tearDown {
    _attachment = nil;
    
    [super tearDown];
}

#pragma mark -
#pragma mark - Test Methods
- (void)testBase64DataEncoding {
    NSData *data = [@"my test string data" dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects([SSPostmarkAttachment base64EndcodeData:data], @"bXkgdGVzdCBzdHJpbmcgZGF0YQ==");
}

- (void)testValidatesPassedFileNameIsValidType {
    XCTAssertTrue([SSPostmarkAttachment nameIsAllowed:@"test.png"]);
    XCTAssertFalse([SSPostmarkAttachment nameIsAllowed:@"test.rar"]);
    XCTAssertFalse([SSPostmarkAttachment nameIsAllowed:@"test.png.text"]);
}
- (void)testShouldThrowIfFileExtentionIsInvalid {
    XCTAssertThrows(self.attachment.name = @"test.text");
    XCTAssertNoThrow(self.attachment.name = @"test.png");
}

@end

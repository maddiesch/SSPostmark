/*!
*  SSPostmarkAttachmentTests.m
*  SSPostmark
*
*  Created by Skylar Schipper on 7/17/14.
*    Copyright (c) 2014 OpenSky, LLC. All rights reserved.
*/

#import <XCTest/XCTest.h>

#import "TestHelpers.h"

@interface SSPostmarkAttachmentTests : XCTestCase

@end

@implementation SSPostmarkAttachmentTests

- (void)testAttachmentContentTypeEncoding {
    XCTAssertEqualObjects([SSPostmarkMessageAttachment contentTypeForFileExtension:@"jpg"], @"image/jpeg");
    XCTAssertEqualObjects([SSPostmarkMessageAttachment contentTypeForFileExtension:@"jpeg"], @"image/jpeg");
    XCTAssertEqualObjects([SSPostmarkMessageAttachment contentTypeForFileExtension:@"gif"], @"image/gif");
    XCTAssertEqualObjects([SSPostmarkMessageAttachment contentTypeForFileExtension:@"png"], @"image/png");
    XCTAssertEqualObjects([SSPostmarkMessageAttachment contentTypeForFileExtension:@"pdf"], @"application/pdf");
    XCTAssertEqualObjects([SSPostmarkMessageAttachment contentTypeForFileExtension:@"m4v"], @"video/x-m4v");
    XCTAssertEqualObjects([SSPostmarkMessageAttachment contentTypeForFileExtension:@"m4a"], @"audio/x-m4a");
    XCTAssertEqualObjects([SSPostmarkMessageAttachment contentTypeForFileExtension:@"txt"], @"text/plain");
    XCTAssertEqualObjects([SSPostmarkMessageAttachment contentTypeForFileExtension:@"dat"], @"application/octet-stream");
}
- (void)testAttachmentsBase64Encoding {
    NSData *data = [@"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet." dataUsingEncoding:NSUTF8StringEncoding];
    NSString *expectedString = @"TmVxdWUgcG9ycm8gcXVpc3F1YW0gZXN0IHF1aSBkb2xvcmVtIGlwc3VtIHF1aWEgZG9sb3Igc2l0IGFtZXQu";
    
    SSPostmarkMessageAttachment *attachment = [[SSPostmarkMessageAttachment alloc] init];
    attachment.fileData = data;
    attachment.filename = @"test.txt";
    
    XCTAssertEqualObjects([attachment base64EncodedData], expectedString);
}
- (void)testAttachmentsJSONEncoding {
    NSData *data = [@"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet." dataUsingEncoding:NSUTF8StringEncoding];
    NSString *expectedString = @"TmVxdWUgcG9ycm8gcXVpc3F1YW0gZXN0IHF1aSBkb2xvcmVtIGlwc3VtIHF1aWEgZG9sb3Igc2l0IGFtZXQu";
    
    SSPostmarkMessageAttachment *attachment = [[SSPostmarkMessageAttachment alloc] init];
    attachment.fileData = data;
    attachment.filename = @"test.txt";
    
    NSDictionary *JSON = [attachment JSONRepresentation];
    
    XCTAssertEqualObjects(JSON[@"Name"], @"test.txt");
    XCTAssertEqualObjects(JSON[@"Content"], expectedString);
    XCTAssertEqualObjects(JSON[@"ContentType"], @"text/plain");
}

@end

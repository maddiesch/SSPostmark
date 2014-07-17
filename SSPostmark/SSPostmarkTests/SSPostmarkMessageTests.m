/*!
*  SSPostmarkMessageTests.m
*  SSPostmark
*
*  Created by Skylar Schipper on 7/16/14.
*    Copyright (c) 2014 OpenSky, LLC. All rights reserved.
*/

@import XCTest;

#import "TestHelpers.h"

#import "SSPostmarkMessagePrivate.h"

@interface SSPostmarkMessageTests : XCTestCase

@end

@implementation SSPostmarkMessageTests

- (void)testMessageValidator {
    SSPostmarkMessage *message = [SSPostmarkMessage new];
    
    XCTAssertFalse([message isValid]);
    
    message.fromAddress = @"example@test.com";
    XCTAssertFalse([message isValid]);
    
    message.subject = @"My Email";
    XCTAssertFalse([message isValid]);
    
    message.textBody = @"Text Body";
    XCTAssertFalse([message isValid]);
    
    message.toAddresses = [NSSet setWithArray:@[@"to@test.com"]];
    XCTAssertTrue([message isValid]);
    
    message.HTMLBody = @"<div>Test</div>";
    XCTAssertTrue([message isValid]);
    
    message.textBody = nil;
    XCTAssertTrue([message isValid]);
    
    message.tag = @"test tag";
    XCTAssertTrue([message isValid]);
    
    message.trackOpens = NO;
    XCTAssertTrue([message isValid]);
    
    message.bccAddresses = [NSSet setWithArray:@[@"bcc@test.com"]];
    XCTAssertTrue([message isValid]);
    
    message.ccAddresses = [NSSet setWithArray:@[@"cc@test.com"]];
    XCTAssertTrue([message isValid]);
    
    message.replyToAddress = @"reply-to@test.com";
    XCTAssertTrue([message isValid]);
}

- (void)testJSONRepresentation {
    SSPostmarkMessage *message = [SSPostmarkMessage new];
    message.fromAddress = @"example@test.com";
    message.subject = @"My Email";
    message.textBody = @"Text Body";
    message.HTMLBody = @"<div>HTML Body</div>";
    message.toAddresses = [NSSet setWithArray:@[@"to@test.com"]];
    message.tag = @"test-tag";
    message.trackOpens = NO;
    message.bccAddresses = [NSSet setWithArray:@[@"bcc@test.com"]];
    message.ccAddresses = [NSSet setWithArray:@[@"cc@test.com",@"\"CC Two\" <cc2@test.com>"]];
    message.replyToAddress = @"reply-to@test.com";
    
    NSDictionary *JSON = [message JSONRepresentation];
    
    XCTAssertNotNil(JSON);
    XCTAssertEqualObjects(JSON[@"From"], @"example@test.com");
    XCTAssertEqualObjects(JSON[@"To"], @"to@test.com");
    XCTAssertEqualObjects(JSON[@"Cc"], @"\"CC Two\" <cc2@test.com>, cc@test.com");
    XCTAssertEqualObjects(JSON[@"Bcc"], @"bcc@test.com");
    XCTAssertEqualObjects(JSON[@"Subject"], @"My Email");
    XCTAssertEqualObjects(JSON[@"Tag"], @"test-tag");
    XCTAssertEqualObjects(JSON[@"HtmlBody"], @"<div>HTML Body</div>");
    XCTAssertEqualObjects(JSON[@"TextBody"], @"Text Body");
    XCTAssertEqualObjects(JSON[@"ReplyTo"], @"reply-to@test.com");
    XCTAssertEqualObjects(JSON[@"TrackOpens"], @NO);
}

@end

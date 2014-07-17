/*!
*  SSPostmarkMessageTests.m
*  SSPostmark
*
*  Created by Skylar Schipper on 7/16/14.
*    Copyright (c) 2014 OpenSky, LLC. All rights reserved.
*/

@import XCTest;

#import "SSPostmarkMessage.h"

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

@end

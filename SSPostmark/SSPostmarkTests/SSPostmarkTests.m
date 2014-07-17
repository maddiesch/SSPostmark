/*!
*  SSPostmarkTests.m
*  SSPostmark
*
*  Created by Skylar Schipper on 7/16/14.
*    Copyright (c) 2014 OpenSky, LLC. All rights reserved.
*/

@import XCTest;

#import "TestHelpers.h"

@interface SSPostmarkTests : XCTestCase

@end

@implementation SSPostmarkTests

- (void)testPostmarkSendAPI {
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
    
    SSAsync *async = [SSAsync async];
    
    SSPostmark *postmark = [[SSPostmark alloc] initWithAPIKey:TEST_POSTMARK_API_KEY];
    [postmark sendMessage:message completion:^(id response, NSError *error) {
        XCTAssertNotNil(response);
        XCTAssertNil(error);
        [async complete];
    }];
    
    XCTAssertTrue([async wait], @"Postmark failed to respond in time");
}

@end

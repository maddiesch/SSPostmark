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
    message.additionalHeaders = [NSSet setWithObject:[SSPostmarkHeaderItem headerWithName:@"MY_HEADER" value:@"My Value"]];
    
    SSAsync *async = [SSAsync async];
    
    SSPostmark *postmark = [[SSPostmark alloc] initWithAPIKey:TEST_POSTMARK_API_KEY];
    [postmark sendMessage:message completion:^(id response, NSError *error) {
        XCTAssertNotNil(response);
        XCTAssertNil(error);
        [async complete];
    }];
    
    XCTAssertTrue([async wait], @"Postmark failed to respond in time");
}

- (void)testPostmarkSendBatchAPI {
    SSPostmarkMessage *message1 = [SSPostmarkMessage new];
    message1.fromAddress = @"example@test.com";
    message1.subject = @"My Email";
    message1.textBody = @"Text Body";
    message1.HTMLBody = @"<div>HTML Body</div>";
    message1.toAddresses = [NSSet setWithArray:@[@"to@test.com"]];
    message1.tag = @"test-tag";
    message1.trackOpens = NO;
    message1.bccAddresses = [NSSet setWithArray:@[@"bcc@test.com"]];
    message1.ccAddresses = [NSSet setWithArray:@[@"cc@test.com",@"\"CC Two\" <cc2@test.com>"]];
    message1.replyToAddress = @"reply-to@test.com";
    
    SSPostmarkMessage *message2 = [SSPostmarkMessage new];
    message2.fromAddress = @"example@test.com";
    message2.subject = @"My Email";
    message2.textBody = @"Text Body";
    message2.HTMLBody = @"<div>HTML Body</div>";
    message2.toAddresses = [NSSet setWithArray:@[@"to@test.com"]];
    message2.tag = @"test-tag";
    message2.trackOpens = NO;
    message2.bccAddresses = [NSSet setWithArray:@[@"bcc@test.com"]];
    message2.ccAddresses = [NSSet setWithArray:@[@"cc@test.com",@"\"CC Two\" <cc2@test.com>"]];
    message2.replyToAddress = @"reply-to@test.com";
    
    SSAsync *async = [SSAsync async];
    
    SSPostmark *postmark = [[SSPostmark alloc] initWithAPIKey:TEST_POSTMARK_API_KEY];
    [postmark sendBatchMessages:@[message1, message2] completion:^(NSArray *responses, NSError *err) {
        XCTAssertNil(err);
        XCTAssertTrue(responses.count == 2);
        for (SSPostmarkResponse *response in responses) {
            XCTAssertNotNil(response);
            XCTAssertNotNil(response.info);
            XCTAssertNotNil(response.messageID);
            XCTAssertNotNil(response.submittedAt);
            XCTAssertEqual(response.errorCode, SSPostmarkAPIErrorCodeNone);
        }
        [async complete];
    }];
    
    XCTAssertTrue([async wait], @"Postmark failed to respond in time");
}

@end

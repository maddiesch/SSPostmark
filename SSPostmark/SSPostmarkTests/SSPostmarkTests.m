//
//  SSPostmarkTests.m
//  SSPostmarkTests
//
//  Created by Skylar Schipper on 12/28/16.
//  Copyright © 2016 Skylar Schipper. All rights reserved.
//

@import XCTest;
@import SSPostmark;

@interface SSPostmarkTests : XCTestCase

@end

@implementation SSPostmarkTests

- (void)testForConfig {
    // Making sure it's all working in Obj-C land
    SSPostmark *pm = [[SSPostmark alloc] initWithApiKey:@"test-key"];
    XCTAssertNotNil(pm);
}

- (void)testDeliver {
    XCTestExpectation *expect = [self expectationWithDescription:@"response"];
    SSPostmark *pm = [[SSPostmark alloc] initWithApiKey:@"POSTMARK_API_TEST"];

    SSMessage *message = [[SSMessage alloc] init];
    message.fromAddress = @"from@test.dev";
    message.subject = @"Testing";
    message.textBody = @"Testing Validation";
    message.toAddresses = @[@"to@test.dev"];

    [pm deliverMessage:message completion:^(SSResponse *response, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertNotNil(response.message);
        XCTAssertNotNil(response.messageID);
        [expect fulfill];
    }];

    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testDeliverWithCustomHeaders {
    XCTestExpectation *expect = [self expectationWithDescription:@"response"];
    SSPostmark *pm = [[SSPostmark alloc] initWithApiKey:@"POSTMARK_API_TEST"];

    SSMessage *message = [[SSMessage alloc] init];
    message.fromAddress = @"from@test.dev";
    message.subject = @"Testing";
    message.textBody = @"Testing Validation";
    message.toAddresses = @[@"to@test.dev"];
    message.additionalHeaders = @[[[SSHeaderItem alloc] initWithName:@"X-Test-Mail-Header" headerValue:@"Test Value"]];

    [pm deliverMessage:message completion:^(SSResponse *response, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertNotNil(response.message);
        XCTAssertNotNil(response.messageID);
        [expect fulfill];
    }];

    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

@end

//
//  SSMessageTests.m
//  SSPostmark
//
//  Created by Skylar Schipper on 12/28/16.
//  Copyright © 2016 Skylar Schipper. All rights reserved.
//

@import XCTest;
@import SSPostmark;

@interface SSMessageTests : XCTestCase

@end

@implementation SSMessageTests

- (void)testMessageFromAddressValidation {
    SSMessage *message = [[SSMessage alloc] init];

    NSError *error = nil;
    XCTAssertFalse([message validateAndReturnError:&error]);
    XCTAssertNotNil(error);
    XCTAssertEqualObjects(error.domain, @"SSPostmarkMessageErrorDomain");
    XCTAssertEqual(error.code, 1);
}

- (void)testMessageSubjectValidation {
    SSMessage *message = [[SSMessage alloc] init];
    message.fromAddress = @"from@test.dev";
    
    NSError *error = nil;
    XCTAssertFalse([message validateAndReturnError:&error]);
    XCTAssertNotNil(error);
    XCTAssertEqualObjects(error.domain, @"SSPostmarkMessageErrorDomain");
    XCTAssertEqual(error.code, 2);
}

- (void)testMessageBodyValidation {
    SSMessage *message = [[SSMessage alloc] init];
    message.fromAddress = @"from@test.dev";
    message.subject = @"Testing";

    NSError *error = nil;
    XCTAssertFalse([message validateAndReturnError:&error]);
    XCTAssertNotNil(error);
    XCTAssertEqualObjects(error.domain, @"SSPostmarkMessageErrorDomain");
    XCTAssertEqual(error.code, 3);
}


- (void)testMessageToValidation {
    SSMessage *message = [[SSMessage alloc] init];
    message.fromAddress = @"from@test.dev";
    message.subject = @"Testing";
    message.textBody = @"Testing Validation";

    NSError *error = nil;
    XCTAssertFalse([message validateAndReturnError:&error]);
    XCTAssertNotNil(error);
    XCTAssertEqualObjects(error.domain, @"SSPostmarkMessageErrorDomain");
    XCTAssertEqual(error.code, 4);
}

- (void)testMessageValidation {
    SSMessage *message = [[SSMessage alloc] init];
    message.fromAddress = @"from@test.dev";
    message.subject = @"Testing";
    message.textBody = @"Testing Validation";
    message.toAddresses = @[@"to@test.dev"];

    NSError *error = nil;
    XCTAssertTrue([message validateAndReturnError:&error]);
    XCTAssertNil(error);
}

@end

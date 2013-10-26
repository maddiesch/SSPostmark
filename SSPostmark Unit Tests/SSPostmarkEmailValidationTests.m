/*!
*  SSPostmarkEmailValidationTests.m
*  SSPostmark
*
*  Created by Skylar Schipper on 10/25/13.
*    Copyright (c) 2013 Skylar Schipper. All rights reserved.
*/

#import <XCTest/XCTest.h>
#import "SSPostmarkValidators.h"

@interface SSPostmarkEmailValidationTests : XCTestCase

@end

@implementation SSPostmarkEmailValidationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark -
#pragma mark - Test Methods
- (void)testStrictValidator {
    XCTAssertFalse([SSPostmarkValidators validatesEmail:@"" type:SSPostmarkEmailAddressValidateStrict]);
    XCTAssertFalse([SSPostmarkValidators validatesEmail:@"test" type:SSPostmarkEmailAddressValidateStrict]);
    XCTAssertFalse([SSPostmarkValidators validatesEmail:@"test@example" type:SSPostmarkEmailAddressValidateStrict]);
    XCTAssertFalse([SSPostmarkValidators validatesEmail:@".test@example.com" type:SSPostmarkEmailAddressValidateStrict]);
    XCTAssertFalse([SSPostmarkValidators validatesEmail:@"test@example.c" type:SSPostmarkEmailAddressValidateStrict]);
    XCTAssertFalse([SSPostmarkValidators validatesEmail:@"test@example.abcdefghikj" type:SSPostmarkEmailAddressValidateStrict]);
    XCTAssertTrue([SSPostmarkValidators validatesEmail:@"test@example.com" type:SSPostmarkEmailAddressValidateStrict]);
    XCTAssertTrue([SSPostmarkValidators validatesEmail:@"test+filter@example.com" type:SSPostmarkEmailAddressValidateStrict]);
}
- (void)testLaxValidator {
    XCTAssertFalse([SSPostmarkValidators validatesEmail:@"" type:SSPostmarkEmailAddressValidateLax]);
    XCTAssertFalse([SSPostmarkValidators validatesEmail:@"test" type:SSPostmarkEmailAddressValidateLax]);
    XCTAssertFalse([SSPostmarkValidators validatesEmail:@"test@example" type:SSPostmarkEmailAddressValidateLax]);
    XCTAssertFalse([SSPostmarkValidators validatesEmail:@"test@example.c" type:SSPostmarkEmailAddressValidateLax]);
    XCTAssertTrue([SSPostmarkValidators validatesEmail:@"test@example.com" type:SSPostmarkEmailAddressValidateLax]);
    XCTAssertTrue([SSPostmarkValidators validatesEmail:@"test+filter@example.com" type:SSPostmarkEmailAddressValidateLax]);
}

@end

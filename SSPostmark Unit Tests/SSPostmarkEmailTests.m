/*!
*  SSPostmarkEmailTests.m
*  SSPostmark
*
*  Created by Skylar Schipper on 10/25/13.
*    Copyright (c) 2013 Skylar Schipper. All rights reserved.
*/

#import <XCTest/XCTest.h>
#import "SSPostmarkEmail.h"

@interface SSPostmarkEmailTests : XCTestCase

@property (nonatomic, strong) SSPostmarkEmail *email;

@end

@implementation SSPostmarkEmailTests

- (void)setUp {
    [super setUp];
    
    self.email = [[SSPostmarkEmail alloc] init];
    [self.email.toAddresses addObject:@"test@example.com"];
    self.email.fromAddress = @"testfrom@example.com";
}

- (void)tearDown {
    _email = nil;
    
    [super tearDown];
}

#pragma mark -
#pragma mark - Test Methods
- (void)testEmailVaildator {
    XCTAssertTrue([self.email isValid]);
}

- (void)testValidatePresenceFailsIfNoToAddresses {
    [self.email.toAddresses removeAllObjects];
    
    XCTAssertFalse([self.email isValid]);
    XCTAssertTrue(self.email.errors.count == 1, @"Should have 1 error got (%lu)",self.email.errors.count);
    SSPostmarkValidationError *error = [self.email.errors lastObject];
    XCTAssertTrue(error.code == 100);
}
- (void)testValidateFailsIfNoFromAddresse {
    self.email.fromAddress = nil;
    
    XCTAssertFalse([self.email isValid]);
    XCTAssertTrue(self.email.errors.count == 1, @"Should have 1 error got (%lu)",self.email.errors.count);
    SSPostmarkValidationError *error = [self.email.errors lastObject];
    XCTAssertTrue(error.code == 101);
}
- (void)testValidateFailIfThereIsNoSubjectAndValidationOn {
    self.email.subject = nil;
    self.email.validations |= SSPostmarkEmailValidateSubject;
    
    XCTAssertFalse([self.email isValid]);
    XCTAssertTrue(self.email.errors.count == 1);
    SSPostmarkValidationError *error = [self.email.errors lastObject];
    XCTAssertTrue(error.code == 102);
}
- (void)testToAddressesValidatesAddressesByDefault {
    [self.email.toAddresses removeAllObjects];
    [self.email.toAddresses addObject:@""];
    
    XCTAssertFalse([self.email isValid]);
    XCTAssertTrue(self.email.errors.count == 1);
    SSPostmarkValidationError *error = [self.email.errors lastObject];
    XCTAssertTrue(error.code == 1);
}
- (void)testToAddressesVaidatesWithValidAddress {
    XCTAssertTrue([self.email isValid]);
}
- (void)testToAddressesDoesntValidateNoValidations {
    [self.email.toAddresses removeAllObjects];
    self.email.validations = SSPostmarkEmailValidationsNone;
    XCTAssertTrue([self.email isValid]);
}

- (void)testFromAddressValidEmail {
    self.email.validations |= SSPostmarkEmailValidateFromAddress;
    XCTAssertTrue([self.email isValid]);
}
- (void)testFromAddressErrorsOnInvalidAddress {
    self.email.validations |= SSPostmarkEmailValidateFromAddress;
    self.email.fromAddress = @"invalid@example";
    XCTAssertFalse([self.email isValid]);
    XCTAssertTrue(self.email.errors.count == 1);
    SSPostmarkValidationError *error = [self.email.errors lastObject];
    XCTAssertTrue(error.code == 2);
}

- (void)testCCAddressValidEmail {
    self.email.validations |= SSPostmarkEmailValidateCCAddress;
    [self.email.ccAddresses addObject:@"test@example.com"];
    XCTAssertTrue([self.email isValid]);
}
- (void)testCCAddressErrorsOnInvalidAddress {
    self.email.validations |= SSPostmarkEmailValidateCCAddress;
    [self.email.ccAddresses addObject:@"invalid@example"];
    XCTAssertFalse([self.email isValid]);
    XCTAssertTrue(self.email.errors.count == 1);
    SSPostmarkValidationError *error = [self.email.errors lastObject];
    XCTAssertTrue(error.code == 3);
}

- (void)testBCCAddressValidEmail {
    self.email.validations |= SSPostmarkEmailValidateBCCAddress;
    [self.email.bccAddresses addObject:@"test@example.com"];
    XCTAssertTrue([self.email isValid]);
}
- (void)testBCCAddressErrorsOnInvalidAddress {
    self.email.validations |= SSPostmarkEmailValidateBCCAddress;
    [self.email.bccAddresses addObject:@"invalid@example"];
    XCTAssertFalse([self.email isValid]);
    XCTAssertTrue(self.email.errors.count == 1);
    SSPostmarkValidationError *error = [self.email.errors lastObject];
    XCTAssertTrue(error.code == 4);
}

- (void)testValidatesNumberOfRecipients {
    for (NSUInteger i = 0; i < 8; i++) {
        [self.email.toAddresses addObject:[NSString stringWithFormat:@"test-%lu@example.com",i]];
    }
    for (NSUInteger i = 0; i < 8; i++) {
        [self.email.ccAddresses addObject:[NSString stringWithFormat:@"test-cc-%lu@example.com",i]];
    }
    for (NSUInteger i = 0; i < 8; i++) {
        [self.email.bccAddresses addObject:[NSString stringWithFormat:@"test-bcc-%lu@example.com",i]];
    }
    XCTAssertFalse([self.email isValid]);
    XCTAssertTrue(self.email.errors.count == 1);
    SSPostmarkValidationError *error = [self.email.errors lastObject];
    XCTAssertTrue(error.code == 200);
}

@end

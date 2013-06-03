#import "Kiwi.h"
#import "SSPostmarkEmail.h"

SPEC_BEGIN(SSPostmarkEmailTest)

static SSPostmarkEmail *_email = nil;
beforeEach(^{
    _email = [[SSPostmarkEmail alloc] init];
    [_email.toAddresses addObject:@"test@example.com"];
    _email.fromAddress = @"testfrom@example.com";
});
afterEach(^{
    _email = nil;
});

it(@"is valid", ^{
    [[theValue([_email isValid]) should] equal:theValue(YES)];
});

describe(@"validations", ^{
    describe(@"presence", ^{
        it(@"failes if there are no to addresses", ^{
            [_email.toAddresses removeAllObjects];
            [[theValue([_email isValid]) should] equal:theValue(NO)];
            [[theValue([[_email errors] count]) should] equal:theValue(1)];
            SSPostmarkValidationError *error = [[_email errors] lastObject];
            [[theValue([error code]) should] equal:theValue(100)];
        });
        it(@"failes if there are no from addresses", ^{
            _email.fromAddress = nil;
            [[theValue([_email isValid]) should] equal:theValue(NO)];
            [[theValue([[_email errors] count]) should] equal:theValue(1)];
            SSPostmarkValidationError *error = [[_email errors] lastObject];
            [[theValue([error code]) should] equal:theValue(101)];
        });
        it(@"failes if there is no subject and vaildation is turned on", ^{
            _email.subject = nil;
            _email.validations |= SSPostmarkEmailValidateSubject;
            [[theValue([_email isValid]) should] equal:theValue(NO)];
            [[theValue([[_email errors] count]) should] equal:theValue(1)];
            SSPostmarkValidationError *error = [[_email errors] lastObject];
            [[theValue([error code]) should] equal:theValue(102)];
        });
        it(@"failes if there is no subject and vaildation is turned off", ^{
            _email.subject = nil;
            [[theValue([_email isValid]) should] equal:theValue(YES)];
        });
    });
    describe(@"to addresses", ^{
        it(@"validates address by default", ^{
            [_email.toAddresses removeAllObjects];
            [_email.toAddresses addObject:@""];
            [[theValue([_email isValid]) should] equal:theValue(NO)];
            [[theValue([[_email errors] count]) should] equal:theValue(1)];
            SSPostmarkValidationError *error = [[_email errors] lastObject];
            [[theValue([error code]) should] equal:theValue(1)];
        });
        it(@"is valid with a valid address", ^{
            [[theValue([_email isValid]) should] equal:theValue(YES)];
        });
        it(@"doesn't validate address if none is set", ^{
            _email.validations = SSPostmarkEmailValidationsNone;
            [[theValue([_email isValid]) should] equal:theValue(YES)];
        });
    });
    
    describe(@"from addresses", ^{
        it(@"validates valid addresses", ^{
            _email.validations |= SSPostmarkEmailValidateFromAddress;
            NSLog(@"%@",[_email errors]);
            [[theValue([_email isValid]) should] equal:theValue(YES)];
        });
        it(@"validates invalid addresses", ^{
            _email.validations |= SSPostmarkEmailValidateFromAddress;
            _email.fromAddress = @"invalid@example";
            [[theValue([_email isValid]) should] equal:theValue(NO)];
            [[theValue([[_email errors] count]) should] equal:theValue(1)];
            SSPostmarkValidationError *error = [[_email errors] lastObject];
            [[theValue([error code]) should] equal:theValue(2)];
        });
    });
    describe(@"cc addresses", ^{
        it(@"validates valid addresses", ^{
            _email.validations |= SSPostmarkEmailValidateCCAddress;
            [_email.ccAddresses addObject:@"test@example.com"];
            [[theValue([_email isValid]) should] equal:theValue(YES)];
        });
        it(@"validates invalid addresses", ^{
            _email.validations |= SSPostmarkEmailValidateCCAddress;
            [_email.ccAddresses addObject:@"invalid@example"];
            [[theValue([_email isValid]) should] equal:theValue(NO)];
            [[theValue([[_email errors] count]) should] equal:theValue(1)];
            SSPostmarkValidationError *error = [[_email errors] lastObject];
            [[theValue([error code]) should] equal:theValue(3)];
        });
    });
    describe(@"bcc addresses", ^{
        it(@"validates valid addresses", ^{
            _email.validations |= SSPostmarkEmailValidateBCCAddress;
            [_email.bccAddresses addObject:@"test@example.com"];
            [[theValue([_email isValid]) should] equal:theValue(YES)];
        });
        it(@"validates invalid addresses", ^{
            _email.validations |= SSPostmarkEmailValidateBCCAddress;
            [_email.bccAddresses addObject:@"invalid@example"];
            [[theValue([_email isValid]) should] equal:theValue(NO)];
            [[theValue([[_email errors] count]) should] equal:theValue(1)];
            SSPostmarkValidationError *error = [[_email errors] lastObject];
            [[theValue([error code]) should] equal:theValue(4)];
        });
    });
    
});

SPEC_END
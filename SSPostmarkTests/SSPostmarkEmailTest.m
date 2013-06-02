#import "Kiwi.h"
#import "SSPostmarkEmail.h"

SPEC_BEGIN(SSPostmarkEmailTest)

static SSPostmarkEmail *_email = nil;
beforeEach(^{
    _email = [[SSPostmarkEmail alloc] init];
});
afterEach(^{
    _email = nil;
});

describe(@"validations", ^{
    it(@"validates address by default", ^{
        _email.address = @"";
        [[theValue([_email isValid]) should] equal:theValue(NO)];
        [[theValue([[_email errors] count]) should] equal:theValue(1)];
        NSError *error = [[_email errors] lastObject];
        [[theValue([error code]) should] equal:theValue(1)];
    });
    it(@"is invalid if address is nil", ^{
        _email.address = nil;
        [[theValue([_email isValid]) should] equal:theValue(NO)];
        [[theValue([[_email errors] count]) should] equal:theValue(1)];
        NSError *error = [[_email errors] lastObject];
        [[theValue([error code]) should] equal:theValue(1)];
    });
    it(@"is valid with a valid address", ^{
        _email.address = @"test@example.com";
        [[theValue([_email isValid]) should] equal:theValue(YES)];
    });
    it(@"doesn't validate address if none is set", ^{
        _email.validations = SSPostmarkEmailValidationsNone;
        [[theValue([_email isValid]) should] equal:theValue(YES)];
    });
});

SPEC_END
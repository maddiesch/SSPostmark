#import "Kiwi.h"
#import "SSPostmarkValidators.h"

SPEC_BEGIN(SSPostmarkEmailValidationTest)

describe(@"validates emails", ^{
    context(@"strict", ^{
        it(@"checks emails", ^{
            [[theValue([SSPostmarkValidators validatesEmail:@"" type:SSPostmarkEmailAddressValidateStrict]) should] equal:theValue(NO)];
            [[theValue([SSPostmarkValidators validatesEmail:@"test" type:SSPostmarkEmailAddressValidateStrict]) should] equal:theValue(NO)];
            [[theValue([SSPostmarkValidators validatesEmail:@"test@example" type:SSPostmarkEmailAddressValidateStrict]) should] equal:theValue(NO)];
            [[theValue([SSPostmarkValidators validatesEmail:@".test@example.com" type:SSPostmarkEmailAddressValidateStrict]) should] equal:theValue(NO)];
            [[theValue([SSPostmarkValidators validatesEmail:@"test@example.c" type:SSPostmarkEmailAddressValidateStrict]) should] equal:theValue(NO)];
            [[theValue([SSPostmarkValidators validatesEmail:@"test@example.abcdefghikj" type:SSPostmarkEmailAddressValidateStrict]) should] equal:theValue(NO)];
            [[theValue([SSPostmarkValidators validatesEmail:@"test@example.com" type:SSPostmarkEmailAddressValidateStrict]) should] equal:theValue(YES)];
            [[theValue([SSPostmarkValidators validatesEmail:@"test+filter@example.com" type:SSPostmarkEmailAddressValidateStrict]) should] equal:theValue(YES)];
        });
    });
    context(@"lax", ^{
        it(@"checks emails", ^{
            [[theValue([SSPostmarkValidators validatesEmail:@"" type:SSPostmarkEmailAddressValidateLax]) should] equal:theValue(NO)];
            [[theValue([SSPostmarkValidators validatesEmail:@"test" type:SSPostmarkEmailAddressValidateLax]) should] equal:theValue(NO)];
            [[theValue([SSPostmarkValidators validatesEmail:@"test@example" type:SSPostmarkEmailAddressValidateLax]) should] equal:theValue(NO)];
            [[theValue([SSPostmarkValidators validatesEmail:@"test@example.c" type:SSPostmarkEmailAddressValidateLax]) should] equal:theValue(NO)];
            [[theValue([SSPostmarkValidators validatesEmail:@"test@example.com" type:SSPostmarkEmailAddressValidateLax]) should] equal:theValue(YES)];
            [[theValue([SSPostmarkValidators validatesEmail:@"test+filter@example.com" type:SSPostmarkEmailAddressValidateLax]) should] equal:theValue(YES)];
        });
    });
});

SPEC_END
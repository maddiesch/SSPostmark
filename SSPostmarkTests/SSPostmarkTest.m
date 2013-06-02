#import "Kiwi.h"


SPEC_BEGIN(SSPostmarkTest)

it(@"tests setup", ^{
    [[theValue(1) should] equal:theValue(1)];
});

SPEC_END
#import "Kiwi.h"
#import "SSPostmark.h"

// If this file isn't found look at TEST_API_KEY_example.h for creating your own.
#import "TEST_API_KEY.h"


static SSPostmark *_postmark = nil;
SPEC_BEGIN(SSPostmarkTest)


beforeEach(^{
    _postmark = [[SSPostmark alloc] initWithApiKey:POSTMARK_TEST_API_KEY];
});
afterEach(^{
    _postmark = nil;
});


SPEC_END
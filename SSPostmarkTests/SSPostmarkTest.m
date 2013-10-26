#import <XCTest/XCTest.h>
#import "SSPostmark.h"

// If this file isn't found look at TEST_API_KEY_example.h for creating your own.
#import "TEST_API_KEY_example.h"

@interface SSPostmarkTest : XCTestCase

@end

@implementation SSPostmarkTest

- (void)testTesting {
    
}

@end

/*
static SSPostmark *_postmark = nil;
SPEC_BEGIN(SSPostmarkTest)


beforeEach(^{
    _postmark = [[SSPostmark alloc] initWithApiKey:POSTMARK_TEST_API_KEY];
});
afterEach(^{
    _postmark = nil;
});


 SPEC_END
 */
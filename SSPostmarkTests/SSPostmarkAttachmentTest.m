#import <XCTest/XCTest.h>
#import "SSPostmarkAttachment.h"

/*
SPEC_BEGIN(SSPostmarkAttachmentTest)

static SSPostmarkAttachment *_attachment = nil;
beforeEach(^{
    _attachment = [[SSPostmarkAttachment alloc] init];
});
afterEach(^{
    _attachment = nil;
});

describe(@"file extention", ^{
    it(@"validates that the passed name has a valid file extention", ^{
        [[theValue([SSPostmarkAttachment nameIsAllowed:@"test.png"]) should] equal:theValue(YES)];
    });
    it(@"failes if extentions is not found", ^{
        [[theValue([SSPostmarkAttachment nameIsAllowed:@"test.png.text"]) should] equal:theValue(NO)];
    });
    it(@"raises exception if the file extention is invalid", ^{
        [[theBlock(^{
            _attachment.name = @"test.text";
        }) should] raiseWithName:SSPostmarkAttachmentInvalidNameException];
    });
    it(@"does not raise exception if name is valid", ^{
        [[theBlock(^{
            _attachment.name = @"test.png";
        }) shouldNot] raiseWithName:SSPostmarkAttachmentInvalidNameException];
    });
});

describe(@"base64 encode", ^{
    it(@"encodes string", ^{
        NSData *data = [@"my test string data" dataUsingEncoding:NSUTF8StringEncoding];
        [[[SSPostmarkAttachment base64EndcodeData:data] should] equal:@"bXkgdGVzdCBzdHJpbmcgZGF0YQ=="];
    });
});

SPEC_END
*/
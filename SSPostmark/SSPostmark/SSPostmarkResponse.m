/*!
 * SSPostmarkResponse.m
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/16/14
 */

#import "SSPostmarkResponsePrivate.h"
#import "SSPostmark.h"

@interface SSPostmarkResponse ()

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSError *JSONParseError;

@end

@implementation SSPostmarkResponse

- (instancetype)initWithData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError *)error {
    self = [super init];
    if (self) {
        self.data = data;
        self.response = response;
        self.error = error;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ MessageID: %@ Error Code: %li Info: %@>",NSStringFromClass(self.class),self.messageID,(long)self.errorCode,self.info];
}

- (void)setData:(NSData *)data {
    _data = data;
    if (_data) {
        NSError *err = nil;
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:_data options:0 error:&err];
        if (err) {
            self.JSONParseError = err;
        }
        self.errorCode = [info[@"ErrorCode"] integerValue];
        self.info = info[@"Message"];
        self.messageID = info[@"MessageID"];
        self.submittedAt = info[@"SubmittedAt"];
    }
}

- (NSError *)responseError {
    if (self.error) {
        return [NSError errorWithDomain:SSPostmarkErrorDomain
                                   code:SSPostmarkErrorCodeCocoa
                               userInfo:@{
                                          NSLocalizedDescriptionKey: NSLocalizedString(@"Failed to send request.", nil),
                                          NSUnderlyingErrorKey: self.error
                                          }];
    }
    if (self.response.statusCode < 200 | self.response.statusCode >= 300) {
        return [NSError errorWithDomain:SSPostmarkErrorDomain
                                   code:SSPostmarkErrorCodePostmarkHTTP
                               userInfo:@{
                                          NSLocalizedDescriptionKey: NSLocalizedString(@"Failed to send request.", nil),
                                          NSUnderlyingErrorKey: [NSError errorWithDomain:@"SSPostmarkHTTPError" code:self.response.statusCode userInfo:nil]
                                          }];
    }
    if (self.JSONParseError) {
        return [NSError errorWithDomain:SSPostmarkErrorDomain
                                   code:SSPostmarkErrorCodeJSONResponseError
                               userInfo:@{
                                          NSLocalizedDescriptionKey: NSLocalizedString(@"Failed to parse response JSON.", nil),
                                          NSUnderlyingErrorKey: self.JSONParseError
                                          }];
    }
    
    return nil;
}

@end

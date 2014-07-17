//
//  SSPostmark.m
//  SSPostmark
//
//  Created by Skylar Schipper on 7/16/14.
//  Copyright (c) 2014 OpenSky, LLC. All rights reserved.
//

#import "SSPostmark.h"

#import "SSPostmarkResponsePrivate.h"
#import "SSPostmarkMessagePrivate.h"

@interface SSPostmark ()

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong, readwrite) NSString *apiKey;

@end

@implementation SSPostmark

- (instancetype)initWithAPIKey:(NSString *)apiKey {
    self = [super init];
    if (self) {
        self.apiKey = apiKey;
    }
    return self;
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{
                                                @"X-Postmark-Server-Token": self.apiKey,
                                                @"Accept": @"application/json",
                                                @"Content-Type": @"application/json"
                                                };
        
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return _session;
}

- (void)sendMessage:(SSPostmarkMessage *)message completion:(void(^)(SSPostmarkResponse *, NSError *))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (![message isValid]) {
            NSError *error = [NSError errorWithDomain:SSPostmarkErrorDomain
                                                 code:SSPostmarkErrorCodeInvalidMessage
                                             userInfo:@{
                                                        NSLocalizedDescriptionKey: NSLocalizedString(@"Message invalid", nil)
                                                        }];
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        
        NSError *JSONError = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:[message JSONRepresentation] options:0 error:&JSONError];
        
        if (JSONError) {
            NSError *error = [NSError errorWithDomain:SSPostmarkErrorDomain
                                                 code:SSPostmarkErrorCodeJSONError
                                             userInfo:@{
                                                        NSLocalizedDescriptionKey: NSLocalizedString(@"JSON encoding error", nil),
                                                        NSUnderlyingErrorKey: JSONError
                                                        }];
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        
        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:[self newRequestForMessageData:data] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            SSPostmarkResponse *res = [[SSPostmarkResponse alloc] initWithData:data response:(NSHTTPURLResponse *)response error:error];
            if (completion) {
                completion(res, [res responseError]);
            }
        }];
        [task resume];
    });
}

- (NSURLRequest *)newRequestForMessageData:(NSData *)message {
    static NSURL *URL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        URL = [NSURL URLWithString:@"https://api.postmarkapp.com/email"];
    });
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    request.HTTPBody = message;
    
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)message.length] forHTTPHeaderField:@"Content-Length"];
    
    return request;
}

@end

NSString *const SSPostmarkErrorDomain = @"SSPostmarkErrorDomain";

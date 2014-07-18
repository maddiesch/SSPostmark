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

- (dispatch_queue_t)queue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.SSPostmark.MessageHandler", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

- (NSURLRequest *)newRequestForMessageData:(NSData *)message {
    static NSURL *URL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        URL = [NSURL URLWithString:@"http://api.postmarkapp.com/email"];
    });
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    request.HTTPBody = message;
    
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)message.length] forHTTPHeaderField:@"Content-Length"];
    
    return request;
}
- (NSURLRequest *)newBatchForMessagesData:(NSData *)messages {
    static NSURL *URL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        URL = [NSURL URLWithString:@"http://api.postmarkapp.com/email/batch"];
    });
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    request.HTTPBody = messages;
    
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)messages.length] forHTTPHeaderField:@"Content-Length"];
    
    return request;
}

- (void)sendMessage:(SSPostmarkMessage *)message completion:(void(^)(SSPostmarkResponse *, NSError *))completion {
    dispatch_async(self.queue, ^{
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

- (void)sendBatchMessages:(NSArray *)messages completion:(void(^)(NSArray *, NSError *))completion {
    dispatch_async(self.queue, ^{
        if (messages.count > 500) {
            NSError *error = [NSError errorWithDomain:SSPostmarkErrorDomain
                                                 code:SSPostmarkErrorCodeBatchCountExceeded
                                             userInfo:@{
                                                        NSLocalizedDescriptionKey: NSLocalizedString(@"Can't send more than 500 messages at once", nil)
                                                        }];
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        NSMutableArray *JSONMessages = [NSMutableArray arrayWithCapacity:messages.count];
        for (SSPostmarkMessage *message in messages) {
            [JSONMessages addObject:[message JSONRepresentation]];
        }
        
        NSError *JSONError = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:JSONMessages options:0 error:&JSONError];
        
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
        
        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:[self newBatchForMessagesData:data] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSArray *responses = [SSPostmarkResponse responsesWithData:data response:(NSHTTPURLResponse *)response error:error];
            if (completion) {
                completion(responses, nil);
            }
        }];
        [task resume];
    });
}

@end

NSString *const SSPostmarkErrorDomain = @"SSPostmarkErrorDomain";

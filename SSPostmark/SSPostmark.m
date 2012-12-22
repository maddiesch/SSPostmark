// SSPostmark.m
// 
// Copyright (c) 2012 Skylar Schipper
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
// 
// Redistributions of source code must retain the above copyright notice, this 
// list of conditions and the following disclaimer. Redistributions in binary 
// form must reproduce the above copyright notice, this list of conditions and 
// the following disclaimer in the documentation and/or other materials 
// provided with the distribution. Neither the name of the nor the names of 
// its contributors may be used to endorse or promote products derived from 
// this software without specific prior written permission. 
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
// POSSIBILITY OF SUCH DAMAGE.

#import "SSPostmark.h"

#define pm_API_URL @"http://api.postmarkapp.com/email"
#define pm_BATCH_API_URL @"http://api.postmarkapp.com/email/batch"

SSPostmark static *_SSPostmarkShared = nil;

@implementation SSPostmark

#pragma mark -
#pragma mark - Sending Postmark Messages
- (BOOL)sendMessage:(SSPostmarkMessage *)message {
    return [self ss_SendMessage:message];
}


#pragma mark -
#pragma mark - Shared Instance & Initializers
+ (instancetype)postmaster {
    @synchronized(self) {
        if (_SSPostmarkShared == nil)
            _SSPostmarkShared = [[[self class] alloc] init];
    }
    return _SSPostmarkShared;
}
- (id)init {
    if (self = [super init]) {
        _emailQueue = [[NSOperationQueue alloc] init];
        _emailQueue.name = @"com.skylarsch.SSPostmark";
    }
    return self;
}


#pragma mark -
#pragma mark - Meta Helpers
+ (NSString *)version {
    return @"1.0";
}
+ (NSURL *)postmarkAPIURL {
    return [NSURL URLWithString:pm_API_URL];
}
+ (NSURL *)postmarkBatchAPIURL {
    return [NSURL URLWithString:pm_BATCH_API_URL];
}

#pragma mark -
#pragma mark - Private helper methods
- (BOOL)ss_SendMessage:(SSPostmarkMessage *)message {
    if (![message isValid]) {
        return NO;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[self class] postmarkAPIURL]];
    NSString *length = [[NSNumber numberWithInteger:[[message body] length]] stringValue];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[message body]];
    [request setValue:length forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.apiKey forHTTPHeaderField:@"X-Postmark-Server-Token"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:_emailQueue
                           completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error)
    {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)resp;
        NSError *JSONError = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
        if (JSONError != nil) {
            return;
        }
        if (message.completion) {
            message.completion(message, response.statusCode, JSON);
        }
    }];
    return YES;
}

@end

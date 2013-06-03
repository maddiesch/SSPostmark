/***
 *    SSPostmark
 *    @author - Skylar Schipper
 *	   @copyright - (2011 - 2013) (c) Skylar Schipper
 *			(All rights reserved)
 *
 *    SSPostmark.m
 *    6/2/2013
 *
 /////////////////////////////////////////////////////////
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of Skylar Schipper nor the names of any contributors may
 be used to endorse or promote products derived from this software without
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL SKYLAR SCHIPPER BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 /////////////////////////////////////////////////////////
 *
 *
 *
 *
 *
 *
 ***/

#import "SSPostmark.h"
#import "SSPostmarkEmail.h"

@implementation SSPostmark

- (id)initWithApiKey:(NSString *)apiKey {
    NSAssert(apiKey, @"apiKey is required");
    
    self = [super init];
    if (self) {
        _apiKey = apiKey;
    }
    return self;
}

#pragma mark -
#pragma mark - Private Helpers
- (NSURL *)_postmarkEmailAPIURL {
    return [NSURL URLWithString:@"https://api.postmarkapp.com/email"];
}

#pragma mark -
#pragma mark - Send Email
- (void)sendEmail:(SSPostmarkEmail *)email {
    [self sendEmail:email completion:nil];
}
- (void)sendEmail:(SSPostmarkEmail *)email completion:(void(^)(BOOL success, NSError *error))completion {
    NSAssert(email, @"email is required");
    [NSURLConnection sendAsynchronousRequest:[self _requestForEmail:email] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
        if (!response && error != nil) {
            NSError *networkError = [NSError errorWithDomain:SSPostmarkNetworkErrorDomain code:[error code] userInfo:[error userInfo]];
            completion(NO, networkError);
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200 && completion) {
            completion(YES, nil);
            return;
        }
        if (httpResponse.statusCode == 401 && completion) {
            NSError *apiError = [NSError errorWithDomain:SSPostmarkAPIErrorDomain code:401 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Missing or incorrect API Key header.", nil)}];
            completion(NO, apiError);
            return;
        }
        if (httpResponse.statusCode == 422 && completion) {
            NSError *apiError = [NSError errorWithDomain:SSPostmarkAPIErrorDomain code:422 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Something with the message is not quite right (either malformed JSON or incorrect fields).", nil), @"responseBodyData" : responseData}];
            completion(NO, apiError);
            return;
        }
        if (httpResponse.statusCode == 500 && completion) {
            NSError *apiError = [NSError errorWithDomain:SSPostmarkAPIErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Internal Server Error", nil)}];
            completion(NO, apiError);
            return;
        }
    }];
}

- (NSMutableURLRequest *)_requestForEmail:(SSPostmarkEmail *)email {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self _postmarkEmailAPIURL]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[email binaryJSON]];
    
    [request setValue:[NSString stringWithFormat:@"%i",[[request HTTPBody] length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.apiKey forHTTPHeaderField:@"X-Postmark-Server-Token"];
    
    return request;
}

@end

NSString * const SSPostmarkAPIErrorDomain = @"com.skylarsch.postmark_api_error";
NSString * const SSPostmarkNetworkErrorDomain = @"com.skylarsch.sspostmark_network_error";

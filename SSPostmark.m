/***
 *    QuietSight Framework
 *    @author - Skylar Schipper
 *	   @copyright - (2011 - 2012) (c) Skylar Schipper
 *			(All rights reserved)
 *
 *    SSPostmark.m
 *    1/27/2012
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

#define pm_API_URL @"http://api.postmarkapp.com/email"


@interface SSPostmark () {
    @private
    NSMutableURLRequest* _request;
}
-(void)createHeaders;
-(void)sendEmailWithParamaters:(NSDictionary *)params;
-(BOOL)isValidMailDict:(NSDictionary *)message;

-(NSData*)writeJSON:(NSDictionary*)dict;
-(NSDictionary*)parseJSON:(NSData*)data;
@end

@implementation SSPostmark
@synthesize delegate;

-(void)sendEmailWithParamaters:(NSDictionary *)params asynchronously:(BOOL)async {
    if (async) {
        NSBlockOperation* opp = [[NSBlockOperation alloc]init];
        [opp addExecutionBlock:^{
            [self sendEmailWithParamaters:params];
        }];
        NSOperationQueue* queue = [[NSOperationQueue alloc]init];
        queue.name = pm_ASYNC_QUEUE_NAME;
        [queue addOperation:opp];
    } else {
        [self sendEmailWithParamaters:params];
    }
}
-(void)sendEmailWithParamaters:(NSDictionary *)params {
    NSURL* apiURL = [NSURL URLWithString:pm_API_URL];
    // Re-Create Request
    _request = nil;
    _request = [[NSMutableURLRequest alloc] initWithURL:apiURL];
    // Setup Headers
    [self createHeaders];
    if ([self isValidMailDict:params]) {
        // Create Message JSON
        NSData* message = [self writeJSON:params];
        NSString* length = [NSString stringWithFormat:@"%d",[message length]];
        _request.HTTPMethod = @"POST";
        _request.HTTPBody = message;
        [_request setValue:length forHTTPHeaderField:@"Content-Length"];
    } else {
        if ([self delegate] && [[self delegate]respondsToSelector:@selector(postmark:encounteredError:)]) {
            // Send the delegate message back to the main queue
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[self delegate] postmark:self encounteredError:SSPMError_BadMessageDict];
            });
        }
        return;
    }
    // Send the request
    NSURLResponse* theResponse;
    NSError* theError;
    NSData* ret = [NSURLConnection sendSynchronousRequest:_request returningResponse:&theResponse error:&theError]; 
    if (!ret) {
        if ([self delegate] && [[self delegate]respondsToSelector:@selector(postmark:encounteredError:)]) {
            // Send the delegate message back to the main queue
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[self delegate] postmark:self encounteredError:SSPMError_Unknown];
            });
        }
        return;
    }
    NSDictionary* resp = [self parseJSON:ret];
    if ([self delegate] && [[self delegate]respondsToSelector:@selector(postmark:returnedMessage:withStatusCode:)]) {
        // Send the delegate message back to the main queue
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[self delegate] postmark:self returnedMessage:resp withStatusCode:[[resp objectForKey:@"ErrorCode"] integerValue]];
        });
    }
}

#pragma mark - Helper methods
-(NSData*)writeJSON:(NSDictionary *)dict{
    #if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_4_3
    if ([NSJSONSerialization class]) {
        if (!dict) {
            return nil;
        }
        return [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    }
    #endif
    [NSException raise:@"NSJSONSerialization Not Found" format:@"If you're supporting iOS < 5.0 or OSX < 10.7 Please implemnt JSON Encoder"];
    return nil;
}
-(NSDictionary*)parseJSON:(NSData *)data {
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_4_3
    if ([NSJSONSerialization class]) {
        if (!data) {
            return nil;
        }
        return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
#endif
    [NSException raise:@"NSJSONSerialization Not Found" format:@"If you're supporting iOS < 5.0 or OSX < 10.7 Please implemnt JSON Encoder"];
    return nil;
}
-(void)createHeaders {
    [_request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [_request setValue:pm_YOUR_API_KEY forHTTPHeaderField:@"X-Postmark-Server-Token"];
}
-(BOOL)isValidMailDict:(NSDictionary *)message{
    if (![message objectForKey:kSSPostmarkFrom]) {
        return NO;
    }
    if (![message objectForKey:kSSPostmarkTo]) {
        return NO;
    }
    if (![message objectForKey:kSSPostmarkSubject]) {
        return NO;
    }
    if (![message objectForKey:kSSPostmarkTag]) {
        return NO;
    }
    if (![message objectForKey:kSSPostmarkReplyTo]) {
        return NO;
    }
    if (![message objectForKey:kSSPostmarkHTMLBody] && ![message objectForKey:kSSPostmarkTextBody]) {
        return NO;
    }
    return YES;
}
@end

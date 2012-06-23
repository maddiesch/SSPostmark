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
#define pm_BATCH_API_URL @"http://api.postmarkapp.com/email/batch"


@interface SSPostmark () {
    @private
    NSMutableURLRequest* _request;
    NSMutableData *_recievedData;
}
- (void)createHeaders;
- (void)sendEmailWithParamaters:(NSDictionary *)params;
- (BOOL)isValidMailDict:(NSDictionary *)message;

- (NSData *)writeJSON:(id)data;
- (id)parseJSON:(NSData *)data;

- (void)_send:(NSData *)data toURL:(NSURL *)url;
@end

@implementation SSPostmark
@synthesize apiKey = _apiKey, queueName = _queueName, delegate;

- (id)initWithApiKey:(NSString *)apiKey queueName:(NSString *)queueName {
	if ((self = [super init])) {
		self.apiKey = apiKey;
		self.queueName = queueName;
	}
	return self;
}
- (id)initWithApiKey:(NSString *)apiKey {
	return [self initWithApiKey:apiKey queueName:pm_ASYNC_QUEUE_NAME];
}


- (void)sendEmailWithParamaters:(NSDictionary *)params asynchronously:(BOOL)async {
    if (async) {
        NSBlockOperation* opp = [[NSBlockOperation alloc]init];
        [opp addExecutionBlock:^{
            [self sendEmailWithParamaters:params];
        }];
        NSOperationQueue* queue = [[NSOperationQueue alloc]init];
        queue.name = self.queueName;
        [queue addOperation:opp];
    } else {
        [self sendEmailWithParamaters:params];
    }
}
- (void)sendEmailWithParamaters:(NSDictionary *)params {
    NSURL* apiURL = [NSURL URLWithString:pm_API_URL];
    // Re-Create Request
    _request = nil;
    _request = [[NSMutableURLRequest alloc] initWithURL:apiURL];
    // Setup Headers
    [self createHeaders];
    if ([self isValidMailDict:params]) {
        // Create Message JSON
        NSData* message = [self writeJSON:params];
        NSString* length = [[NSNumber numberWithInteger:message.length] stringValue];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:pm_POSTMARK_NOTIFICATION object:self userInfo:resp];
}

- (void)sendEmail:(SSPostmarkMessage *)message {
    NSURL* apiURL = [NSURL URLWithString:pm_API_URL];
    /**
     *  Validate Message Object
     *
     */
    if (![message isValid]) {
        // Send erros to delegate and & Notification Center
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"failed", @"status",
                                   @"Invalid Message", @"message",
                                   nil];
        NSNotification *errorNot = [NSNotification notificationWithName:pm_POSTMARK_NOTIFICATION object:self userInfo:errorDict];
        [[NSNotificationCenter defaultCenter] postNotification:errorNot];
        if ([self delegate] && [[self delegate] respondsToSelector:@selector(postmark:encounteredError:)]) {
            [[self delegate] postmark:self encounteredError:SSPMError_BadMessageDict];
        }
        return;
    }
    /**
     *  Setup the JSON
     * 
     */
    NSData* messageData = [self writeJSON:[message asDict]];
    [self _send:messageData toURL:apiURL];
}
- (void)sendBatchMessages:(NSArray *)messages {
    NSURL* apiURL = [NSURL URLWithString:pm_BATCH_API_URL];
    NSMutableArray *arr = [NSMutableArray new];
    for (NSUInteger i = 0; i < messages.count; i++) {
        SSPostmarkMessage *m = [messages objectAtIndex:i];
        if (![m isValid]) {
            NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"failed", @"status",
                                       @"Invalid Message", @"message",
                                       nil];
            NSNotification *errorNot = [NSNotification notificationWithName:pm_POSTMARK_NOTIFICATION object:self userInfo:errorDict];
            [[NSNotificationCenter defaultCenter] postNotification:errorNot];
            if ([self delegate] && [[self delegate] respondsToSelector:@selector(postmark:encounteredError:)]) {
                [[self delegate] postmark:self encounteredError:SSPMError_BadMessageDict];
            }
            return;
        } else {
            [arr addObject:[m asDict]];
        }
    }
    NSData *data = [self writeJSON:arr];
    [self _send:data toURL:apiURL];
}

- (void)_send:(NSData *)data toURL:(NSURL *)url {
	_recievedData = nil;
    _request = nil;
    _request = [[NSMutableURLRequest alloc] initWithURL:url];
    // Setup Headers
    [self createHeaders];
    NSString* length = [[NSNumber numberWithInteger:data.length] stringValue];
    _request.HTTPMethod = @"POST";
    _request.HTTPBody = data;
    [_request setValue:length forHTTPHeaderField:@"Content-Length"];
    [NSURLConnection connectionWithRequest:_request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse * resp = (NSHTTPURLResponse *)response;
	NSInteger code = resp.statusCode;
    if (code >= 400) {
		NSLog(@"Postmark url returned error %d %@", resp.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:[resp statusCode]]);
        NSNotification *errorNot = [NSNotification notificationWithName:pm_POSTMARK_NOTIFICATION
																 object:self
															   userInfo:[NSDictionary dictionaryWithObject:@"failed" forKey:@"status"]];
		[[NSNotificationCenter defaultCenter] postNotification:errorNot];
        if ([self delegate] && [[self delegate] respondsToSelector:@selector(postmark:encounteredError:)]) {
            [[self delegate] postmark:self encounteredError:SSPMError_Unknown];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSNotification *errorNot = [NSNotification notificationWithName:pm_POSTMARK_NOTIFICATION
															 object:self
														   userInfo:[NSDictionary dictionaryWithObject:@"failed" forKey:@"status"]];
	[[NSNotificationCenter defaultCenter] postNotification:errorNot];
	if ([self delegate] && [[self delegate] respondsToSelector:@selector(postmark:encounteredError:)]) {
		[[self delegate] postmark:self encounteredError:SSPMError_Unknown];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Feedback
    void (^feedback)(NSDictionary *dict) = ^(NSDictionary *dict) {
        if ([self delegate] && [[self delegate] respondsToSelector:@selector(postmark:returnedMessage:withStatusCode:)]) {
            [[self delegate] postmark:self returnedMessage:dict withStatusCode:[[dict objectForKey:@"ErrorCode"] integerValue]];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:pm_POSTMARK_NOTIFICATION object:self userInfo:dict];
    };
    
    id resp = [self parseJSON:_recievedData];
    
    // Single Mail
    if ([resp isKindOfClass:[NSDictionary class]]) {
        if ([[resp objectForKey:@"ErrorCode"] intValue] == 0) {
            feedback(resp);
        }
    }
    // MultiMail
    if ([resp isKindOfClass:[NSArray class]]) {
        NSArray *a = (NSArray *)resp;
        for (NSUInteger i = 0; i < a.count; i++) {
            NSDictionary *d = [a objectAtIndex:i];
            if ([[d objectForKey:@"ErrorCode"] intValue] == 0) {
                feedback(d);
            }
        }
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (_recievedData == nil) {
        _recievedData = [NSMutableData new];
    }
    [_recievedData appendData:data];
}

#pragma mark - Helper methods
- (NSData *)writeJSON:(id)data{
    if ([NSJSONSerialization class]) {
        if (!data) {
            return nil;
        }
        return [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    }
    [NSException raise:@"NSJSONSerialization Not Found" format:@"%s\nIf you're supporting iOS < 5.0 or OSX < 10.7 Please implemnt JSON Encoder",__PRETTY_FUNCTION__];
    return nil;
}
- (id)parseJSON:(NSData *)data {
    if ([NSJSONSerialization class]) {
        if (!data) {
            return nil;
        }
        return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    [NSException raise:@"NSJSONSerialization Not Found" format:@"%s\nIf you're supporting iOS < 5.0 or OSX < 10.7 Please implemnt JSON Encoder",__PRETTY_FUNCTION__];
    return nil;
}
- (void)createHeaders {
    [_request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [_request setValue:self.apiKey forHTTPHeaderField:@"X-Postmark-Server-Token"];
}
- (BOOL)isValidMailDict:(NSDictionary *)message{
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

+ (BOOL)isValidEmail:(NSString *)email {
    if (email == nil) {
        return NO;
    }
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:email options:0 range:NSMakeRange(0, email.length)];
    if (match){
        return YES;
    }
    return NO;
}

@end


/**
 *
 *  SSPostmarkMessage
 *
 *
 */
@implementation SSPostmarkMessage
@synthesize
htmlBody = _htmlBody,
textBody = _textBody,
fromEmail = _fromEmail,
to = _to,
subject = _subject,
tag = _tag,
replyTo = _replyTo,
cc = _cc,
bcc = _bcc,
headers = _headers,
attachments = _attachments;


- (BOOL)isValid {
    if (self.htmlBody == nil && self.textBody == nil) {
        return NO;
    }
    if (self.fromEmail == nil) {
        return NO;
    }
    if (self.to == nil) {
        return NO;
    }
    if (self.subject == nil) {
        return NO;
    }
    if (self.tag == nil) {
        return NO;
    }
    if (self.replyTo == nil) {
        return NO;
    }
    return YES;
}
- (NSDictionary *)asDict {
    NSMutableDictionary *d = [NSMutableDictionary new];
    if (self.htmlBody != nil) {
        [d setObject:self.htmlBody forKey:kSSPostmarkHTMLBody];
    }
    if (self.textBody != nil) {
        [d setObject:self.textBody forKey:kSSPostmarkTextBody];
    }
    [d setObject:self.fromEmail forKey:kSSPostmarkFrom];
    [d setObject:self.to forKey:kSSPostmarkTo];
    [d setObject:self.subject forKey:kSSPostmarkSubject];
    [d setObject:self.tag forKey:kSSPostmarkTag];
    [d setObject:self.replyTo forKey:kSSPostmarkReplyTo];
    if (self.cc != nil) {
        [d setObject:self.cc forKey:kSSPostmarkCC];
    }
    if (self.bcc != nil) {
        [d setObject:self.bcc forKey:kSSPostmarkBCC];
    }
    if (self.headers != nil) {
        [d setObject:self.headers forKey:kSSPostmarkHeaders];
    }
	if (self.attachments != nil) {
        [d setObject:self.attachments forKey:kSSPostmarkAttachments];
    }
    return d;
}

@end

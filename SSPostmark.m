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


@interface SSPostmark ()
- (BOOL)isValidMailDict:(NSDictionary *)message;

- (NSData *)writeJSON:(id)data;
- (id)parseJSON:(NSData *)data;

- (void)_send:(NSData *)data toURL:(NSURL *)url;
@end

@implementation SSPostmark
@synthesize apiKey = _apiKey, delegate;

- (id)initWithApiKey:(NSString *)apiKey {
	if ((self = [super init])) {
		self.apiKey = apiKey;
	}
	return self;
}

- (void)reportError:(SSPMErrorType)errorType message:(NSString *)message {
	// Send errors to delegate and & Notification Center
	NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys: @"failed", @"status", message, @"message", nil];
	NSNotification *errorNot = [NSNotification notificationWithName:pm_POSTMARK_NOTIFICATION object:self userInfo:errorDict];
	[[NSNotificationCenter defaultCenter] postNotification:errorNot];
	if ([self delegate] && [[self delegate] respondsToSelector:@selector(postmark:encounteredError:message:)]) {
		[[self delegate] postmark:self encounteredError:errorType message:message];
	}
}

- (void)reportErrorWithResponseDictionary:(NSDictionary *)dictionary {
	[self reportError:[[dictionary objectForKey:@"ErrorCode"] integerValue] message:[dictionary objectForKey:@"Message"]];
}

- (void)reportFeedbackWithResponseDictionary:(NSDictionary *)dictionary {
	if ([self delegate] && [[self delegate] respondsToSelector:@selector(postmark:returnedMessage:withStatusCode:)]) {
		[[self delegate] postmark:self
				  returnedMessage:dictionary
				   withStatusCode:[[dictionary objectForKey:@"ErrorCode"] integerValue]];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:pm_POSTMARK_NOTIFICATION object:self userInfo:dictionary];
}


- (void)sendEmail:(SSPostmarkMessage *)message {
    NSURL* apiURL = [NSURL URLWithString:pm_API_URL];
	
    if (![message isValid]) {
		[self reportError:SSPMError_BadMessageDict message:@"Invalid Message"];
		return;
    }

    NSData* messageData = [self writeJSON:[message asDict]];
    [self _send:messageData toURL:apiURL];
}


- (void)sendBatchMessages:(NSArray *)messages {
    NSURL* apiURL = [NSURL URLWithString:pm_BATCH_API_URL];
    NSMutableArray *arr = [NSMutableArray new];
	
    for (NSUInteger i = 0; i < messages.count; i++) {
        SSPostmarkMessage *m = [messages objectAtIndex:i];
        if (![m isValid]) {
			[self reportError:SSPMError_BadMessageDict message:@"Invalid Message"];
            return;
        } else {
            [arr addObject:[m asDict]];
        }
    }
	
    NSData *data = [self writeJSON:arr];
    [self _send:data toURL:apiURL];
}


- (void)_send:(NSData *)data toURL:(NSURL *)url {
	
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [self createHeadersWithRequest:request];

    NSString* length = [[NSNumber numberWithInteger:data.length] stringValue];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    [request setValue:length forHTTPHeaderField:@"Content-Length"];
    
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
		
		if (error) {
			[self reportError:SSPMError_Unknown message:[error localizedDescription]];
			return;
		}
				
		NSMutableArray *parsedResponses = [NSMutableArray array];
		id parsedResponse = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
		if ([parsedResponse isKindOfClass:[NSDictionary class]])
			[parsedResponses addObject:parsedResponse]; // Single Email
		else if ([parsedResponse isKindOfClass:[NSArray class]])
			parsedResponses = parsedResponse; // Bulk emails
		
		NSInteger httpResponseCode = [(NSHTTPURLResponse *)response statusCode];
		if (httpResponseCode >= 400) {
			for (NSDictionary *responseJSON in parsedResponses) {	
				[self reportErrorWithResponseDictionary:responseJSON];
			}
			
		} else {
			for (NSDictionary *responseJSON in parsedResponses) {
				NSInteger postmarkStatus = [[responseJSON objectForKey:@"ErrorCode"] integerValue];
				if (postmarkStatus == SSPMError_NoError) {
					[self reportFeedbackWithResponseDictionary:responseJSON];
				} else {
					[self reportErrorWithResponseDictionary:responseJSON];
				}
			}
		}
	}];
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
- (void)createHeadersWithRequest:(NSMutableURLRequest *)request {
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.apiKey forHTTPHeaderField:@"X-Postmark-Server-Token"];
}
								   
- (BOOL)isValidMailDict:(NSDictionary *)message {
    return ([message objectForKey:kSSPostmarkFrom] &&
			[message objectForKey:kSSPostmarkTo] &&
			[message objectForKey:kSSPostmarkSubject] &&
			[message objectForKey:kSSPostmarkTag] &&
			[message objectForKey:kSSPostmarkReplyTo] &&
			([message objectForKey:kSSPostmarkHTMLBody] || [message objectForKey:kSSPostmarkTextBody])
			);
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
    return match != nil;
}

@end


/**
 *
 *  SSPostmarkMessage
 *
 *
 */
@implementation SSPostmarkMessage
@synthesize htmlBody = _htmlBody;
@synthesize textBody = _textBody;
@synthesize fromEmail = _fromEmail;
@synthesize to = _to;
@synthesize subject = _subject;
@synthesize tag = _tag;
@synthesize replyTo = _replyTo;
@synthesize cc = _cc;
@synthesize bcc = _bcc;
@synthesize headers = _headers;
@synthesize attachments = _attachments;


- (BOOL)isValid {
	return (self.htmlBody || self.textBody) && self.fromEmail && self.to && self.subject && self.tag && self.replyTo;
}

- (NSDictionary *)asDict {
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    
	if (self.htmlBody != nil)
        [d setObject:self.htmlBody		forKey:kSSPostmarkHTMLBody];
    if (self.textBody != nil)
        [d setObject:self.textBody		forKey:kSSPostmarkTextBody];
	
    [d setObject:self.fromEmail			forKey:kSSPostmarkFrom];
    [d setObject:self.to				forKey:kSSPostmarkTo];
    [d setObject:self.subject			forKey:kSSPostmarkSubject];
    [d setObject:self.tag				forKey:kSSPostmarkTag];
    [d setObject:self.replyTo			forKey:kSSPostmarkReplyTo];
    if (self.cc != nil)
        [d setObject:self.cc			forKey:kSSPostmarkCC];
    if (self.bcc != nil)
        [d setObject:self.bcc			forKey:kSSPostmarkBCC];
    if (self.headers != nil)
        [d setObject:self.headers		forKey:kSSPostmarkHeaders];
	if (self.attachments != nil)
        [d setObject:self.attachments	forKey:kSSPostmarkAttachments];
	
    return d;
}

@end

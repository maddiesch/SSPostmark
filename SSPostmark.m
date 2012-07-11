/***
 *    SSPostmark
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

- (NSData *)writeJSON:(id)data;
- (id)parseJSON:(NSData *)data;
- (void)ss_send:(NSData *)data toURL:(NSURL *)url;

@end

@implementation SSPostmark
@synthesize apiKey = _apiKey, completion = _completion, delegate;


- (id)initWithApiKey:(NSString *)apiKey {
	self = [super init];
    if (self) {
        self.apiKey = apiKey;
    }
    return self;
}


- (void)sendEmailWithParamaters:(NSDictionary *)params asynchronously:(BOOL)async __deprecated__  { /* no-op */ }
- (void)sendEmailWithParamaters:(NSDictionary *)params __deprecated__ { /* no-op */ }


- (void)sendMessage:(SSPostmarkMessage *)message {
    NSURL* apiURL = [NSURL URLWithString:pm_API_URL];
    
    if (![message isValid]) {
        [self reportError:SSPMError_BadMessageDict message:@"Invalid Message"];
        return;
    }
    
    NSData* messageData = [self writeJSON:[message asDict]];
    [self ss_send:messageData toURL:apiURL];
}

- (void)sendMessage:(SSPostmarkMessage *)message withCompletion:(SSPostmarkCompletionHandler)completion {
	self.completion = completion;
    [self sendMessage:message];
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
    [self ss_send:data toURL:apiURL];
}

- (void)sendBatchMessages:(NSArray *)messages withCompletion:(SSPostmarkCompletionHandler)completion {
	self.completion = completion;
    [self sendBatchMessages:messages];
}

- (void)ss_send:(NSData *)data toURL:(NSURL *)url {
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
				if (postmarkStatus == SSPMError_NoError)
					[self reportFeedbackWithResponseDictionary:responseJSON];
				else
					[self reportErrorWithResponseDictionary:responseJSON];
			}
		}
	}];
}


- (void)createHeadersWithRequest:(NSMutableURLRequest *)request {
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.apiKey forHTTPHeaderField:@"X-Postmark-Server-Token"];
}


#pragma mark - Error handeling
- (void)reportError:(SSPMErrorType)errorType message:(NSString *)message {
	// Send errors to delegate and & Notification Center
	NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys: @"failed", @"status", message, @"message", nil];
	NSNotification *errorNot = [NSNotification notificationWithName:pm_POSTMARK_NOTIFICATION object:self userInfo:errorDict];
	[[NSNotificationCenter defaultCenter] postNotification:errorNot];
	if ([self delegate] && [[self delegate] respondsToSelector:@selector(postmark:encounteredError:message:)]) {
		[[self delegate] postmark:self encounteredError:errorType message:message];
	}
    if (_completion) {
        _completion(errorDict, errorType);
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
    if (_completion) {
        _completion(dictionary, SSPMError_NoError);
    }
}

#pragma mark - Helper methods
- (NSData *)writeJSON:(id)data{
    if ([NSJSONSerialization class]) {
        if (!data) {
            return nil;
        }
        return [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    }

    return nil;
}
- (id)parseJSON:(NSData *)data {
    if ([NSJSONSerialization class]) {
        if (!data) {
            return nil;
        }
        return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }

    return nil;
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

#pragma mark - Class Methods
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

+ (void)sendMessage:(SSPostmarkMessage *)message apiKey:(NSString *)apiKey completion:(SSPostmarkCompletionHandler)completion {
    SSPostmark *pm = [[self alloc] initWithApiKey:apiKey];
	[pm sendMessage:message withCompletion:completion];
}

@end


/**
 *
 *  SSPostmarkMessage
 *
 *
 */
#pragma mark - SSPostmarkMessage
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
@synthesize apiKey = _apiKey;


- (BOOL)isValid {
    return (self.htmlBody || self.textBody) && self.fromEmail && self.to && self.subject && self.tag && self.replyTo;
}

- (NSDictionary *)asDict {
    NSMutableDictionary *d = [NSMutableDictionary new];
    if (self.htmlBody)
        [d setObject:self.htmlBody	forKey:kSSPostmarkHTMLBody];
    
    if (self.textBody)
        [d setObject:self.textBody	forKey:kSSPostmarkTextBody];
    
    [d setObject:self.fromEmail		forKey:kSSPostmarkFrom];
    [d setObject:self.to			forKey:kSSPostmarkTo];
    [d setObject:self.subject		forKey:kSSPostmarkSubject];
    [d setObject:self.tag			forKey:kSSPostmarkTag];
    [d setObject:self.replyTo		forKey:kSSPostmarkReplyTo];

    if (self.cc)
        [d setObject:self.cc		forKey:kSSPostmarkCC];
    if (self.bcc)
        [d setObject:self.bcc		forKey:kSSPostmarkBCC];
    if (self.headers)
        [d setObject:self.headers	forKey:kSSPostmarkHeaders];
	
	
	if (self.attachments != nil) {
        NSMutableArray *attachments = [NSMutableArray new];
        for (NSUInteger i = 0; i < [self.attachments count]; i++) {
            id attachemnt = [self.attachments objectAtIndex:i];
            if ([attachemnt isKindOfClass:[NSDictionary class]]) {
                [attachments addObject:attachemnt];
            } else if ([attachemnt isKindOfClass:[SSPostmarkAttachment class]]) {
                SSPostmarkAttachment *att = (SSPostmarkAttachment *)attachemnt;
                [attachemnt addObject:[att dictionaryRepresentation]];
            }
        }
        [d setObject:attachments forKey:kSSPostmarkAttachments];
    }
    return d;
}

- (void)addAttachment:(SSPostmarkAttachment *)attachment {
    NSMutableArray *hold = nil;
    if (self.attachments == nil) {
        hold = [NSMutableArray new];
    } else {
        hold = [self.attachments mutableCopy];
    }
    [hold addObject:[attachment dictionaryRepresentation]];
    self.attachments = [NSArray arrayWithArray:hold];
}

@end

#pragma mark - SSPostmarkAttachment
@interface SSPostmarkAttachment ()
- (void)ss_addImage:(id)image;
@end

@implementation SSPostmarkAttachment
@synthesize content = _content, contentType = _contentType, name = _name;

- (void)addData:(NSData *)data {
    _content = [data ss_base64String];
}
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
- (void)addImage:(UIImage *)image {
    [self ss_addImage:image];
}
#elif TARGET_OS_MAC
- (void)addImage:(NSImage *)image {
    [self ss_addImage:image];
}
#endif

- (void)ss_addImage:(id)image {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    [self addData:UIImagePNGRepresentation((UIImage *)image)];
#elif TARGET_OS_MAC
    NSImage *img = (NSImage *)image;
    [img lockFocus];
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, img.size.width, img.size.height)];
    [img unlockFocus];
    [self addData:[bitmapRep representationUsingType:NSPNGFileType properties:nil]];
#endif
    if ([self.name length]) {
        if (![self.name hasSuffix:@".png"]) {
            self.name = [NSString stringWithFormat:@"%@.png",self.name];
        }
    } else {
        self.name = NSLocalizedString(@"image.png", @"default image name");
    }
}

- (NSDictionary *)dictionaryRepresentation {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			self.content, kSSPostmarkAttachmentContent,
			self.contentType, kSSPostmarkAttachmentContentType, 
			self.name, kSSPostmarkAttachmentName,
			nil];
}

- (id)init {
    self = [super init];
    if (self) {
        _contentType = @"application/octet-stream"; // Default as per http://developer.postmarkapp.com/developer-build.html#attachments
    }
    return self;
}

+ (SSPostmarkAttachment *)attachmentWithData:(NSData *)content contentType:(NSString *)contentType name:(NSString *)name {
    SSPostmarkAttachment *att = [[self alloc] init];
    att.name = name;
	att.contentType = contentType;
	[att addData:content];
    return att;
}

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
+ (SSPostmarkAttachment *)attachmentWithImage:(UIImage *)image name:(NSString *)name {
    SSPostmarkAttachment *att = [[self alloc] init];
    att.name = name;
    [att addImage:image];
    return att;
}
#elif TARGET_OS_MAC
+ (SSPostmarkAttachment *)attachmentWithImage:(NSImage *)image name:(NSString *)name {
    SSPostmarkAttachment *att = [[self alloc] init];
    att.name = name;
    [att addImage:image];
    return att;
}
#endif

- (void)setContentType:(NSString *)contentType {
    if (contentType == nil) {
        _contentType = @"application/octet-stream";
        return;
    }
    _contentType = contentType;
}

@end


@implementation NSData (SSBase64)

- (NSString *)ss_base64String {
    const unsigned char * rawData = [self bytes];
    char * objPointer;
    char * strResult;
    
    NSUInteger intLength = self.length;
    if (intLength == 0) return nil;
    
    strResult = (char *)calloc(((intLength + 2) / 3) * 4, sizeof(char));
    objPointer = strResult;
    
    while (intLength > 2) {
        *objPointer++ = _base64EncodingTable[rawData[0] >> 2];
        *objPointer++ = _base64EncodingTable[((rawData[0] & 0x03) << 4) + (rawData[1] >> 4)];
        *objPointer++ = _base64EncodingTable[((rawData[1] & 0x0f) << 2) + (rawData[2] >> 6)];
        *objPointer++ = _base64EncodingTable[rawData[2] & 0x3f];
        rawData += 3;
        intLength -= 3; 
    }
    
    if (intLength != 0) {
        *objPointer++ = _base64EncodingTable[rawData[0] >> 2];
        if (intLength > 1) {
            *objPointer++ = _base64EncodingTable[((rawData[0] & 0x03) << 4) + (rawData[1] >> 4)];
            *objPointer++ = _base64EncodingTable[(rawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = _base64EncodingTable[(rawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    *objPointer = '\0';
    
    NSString *retVal = [[NSString alloc] initWithCString:strResult encoding:NSASCIIStringEncoding];
    free(strResult);
    return retVal;
}

@end
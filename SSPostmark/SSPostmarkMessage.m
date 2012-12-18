// SSPostmarkMessage.m
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

#import "SSPostmarkMessage.h"
#import "SSPostmarkAttachment.h"


@implementation SSPostmarkMessage

- (BOOL)isValid {
    return (self.htmlBody || self.textBody) && self.fromEmail && self.to && self.subject && self.tag && self.replyTo;
}

#pragma mark -
#pragma mark -
- (NSData *)body {
    return [NSJSONSerialization dataWithJSONObject:[self dictionaryRepresentation] options:0 error:nil];
}

#pragma mark -
#pragma mark -
- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *d = [NSMutableDictionary new];
    [d setObject:self.fromEmail forKey:kSSPostmarkFrom];
    [d setObject:self.to forKey:kSSPostmarkTo];
    [d setObject:self.subject forKey:kSSPostmarkSubject];
    [d setObject:self.tag forKey:kSSPostmarkTag];
    [d setObject:self.replyTo forKey:kSSPostmarkReplyTo];
    
    if (self.cc)
        [d setObject:self.cc forKey:kSSPostmarkCC];
    if (self.bcc)
        [d setObject:self.bcc forKey:kSSPostmarkBCC];
    if (self.headers)
        [d setObject:self.headers forKey:kSSPostmarkHeaders];
    if (self.htmlBody)
        [d setObject:self.htmlBody forKey:kSSPostmarkHTMLBody];
    if (self.textBody)
        [d setObject:self.textBody forKey:kSSPostmarkTextBody];
    
    if (self.attachments != nil && [self.attachments count] > 0) {
        NSMutableArray *attachments = [NSMutableArray new];
        for (SSPostmarkAttachment *att in [self.attachments allObjects]) {
            [attachments addObject:[att dictionary]];
        }
        [d setObject:attachments forKey:kSSPostmarkAttachments];
    }
    
    return d;
}

#pragma mark -
#pragma mark - Attachments
- (void)addAttachmentsObject:(SSPostmarkAttachment *)object {
    [self addAttachments:[NSSet setWithObject:object]];
}
- (void)addAttachments:(NSSet *)objects {
    if (self.attachments == nil) {
        self.attachments = [NSMutableSet set];
    }
    [self.attachments addObjectsFromArray:[objects allObjects]];
}
- (void)removeAttachmentsObject:(SSPostmarkAttachment *)object {
    [self removeAttachments:[NSSet setWithObject:object]];
}
- (void)removeAttachments:(NSSet *)objects {
    if (self.attachments == nil) {
        return;
    }
    for (id obj in [objects allObjects]) {
        [self.attachments removeObject:obj];
    }
}


#pragma mark -
#pragma mark -
- (void)addCompletionBlock:(SSPostmarkMessageCompletion)completion {
    _completion = completion;
}

@end

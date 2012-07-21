//
//  SSPostmarkMessage.m
//  SSPostmark
//
//  Created by Skylar Schipper on 7/10/12.
//  Copyright (c) 2012 Schipper Studios. All rights reserved.
//

#import "SSPostmarkMessage.h"

@implementation SSPostmarkMessage


- (BOOL)isValid {
    return (self.htmlBody || self.textBody) && self.fromEmail && self.to && self.subject && self.tag && self.replyTo;
}

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

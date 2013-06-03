/***
 *    SSPostmark
 *    @author - Skylar Schipper
 *	   @copyright - (2011 - 2013) (c) Skylar Schipper
 *			(All rights reserved)
 *
 *    SSPostmarkEmail.m
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

#import "SSPostmarkEmail.h"

@interface SSPostmarkEmail ()

@property (nonatomic, strong) NSMutableArray *errorArray;
@property (nonatomic, strong) NSMutableArray *customHeaders;
@property (nonatomic, strong) NSMutableArray *attachments;

@end

@implementation SSPostmarkEmail

- (id)init {
    self = [super init];
    if (self) {
        _validations = SSPostmarkEmailValidateToAddress;
        _emailFormatType = SSPostmarkEmailAddressValidateStrict;
    }
    return self;
}

#pragma mark -
#pragma mark - Message
- (void)setBody:(NSString *)body isHTML:(BOOL)isHTML {
    self.body = body;
    self.html = isHTML;
}

#pragma mark -
#pragma mark - Validations
- (BOOL)isValid {
    [self _performValidations];
    return [self.errorArray count] == 0;
}

- (void)_performValidations {
    [self.errorArray removeAllObjects];
    if (self.validations == SSPostmarkEmailValidationsNone) {
        return;
    }
    [self _performCountValidations];
    [self _performPresenceValidations];
    [self _performEmailAddressValidations];
}
- (void)_performCountValidations {
    if (([self.toAddresses count] + [self.ccAddresses count] + [self.bccAddresses count]) > 20) {
        SSPostmarkValidationError *error = [SSPostmarkValidationError errorForObject:@"To many recipients" failure:200];
        error.instructions = NSLocalizedString(@"Postmark limits the number of recipients to 20 per email", nil);
        [self.errorArray addObject:error];
    }
}
- (void)_performPresenceValidations {
    if ([self.toAddresses count] == 0) {
        SSPostmarkValidationError *error = [SSPostmarkValidationError errorForObject:@"To addresses" failure:100];
        error.instructions = NSLocalizedString(@"Must supply at least one to email address", nil);
        [self.errorArray addObject:error];
    }
    if (!self.fromAddress || [self.fromAddress isEqualToString:@""]) {
        SSPostmarkValidationError *error = [SSPostmarkValidationError errorForObject:@"From addresses" failure:101];
        error.instructions = NSLocalizedString(@"Must supply a from email address", nil);
        [self.errorArray addObject:error];
    }
    if (self.validations & SSPostmarkEmailValidateSubject && (!self.subject || [self.subject isEqualToString:@""])) {
        SSPostmarkValidationError *error = [SSPostmarkValidationError errorForObject:@"Subject" failure:102];
        error.instructions = NSLocalizedString(@"You must supply an email subject", nil);
        [self.errorArray addObject:error];
    }
}
- (void)_performEmailAddressValidations {
    if (self.validations & SSPostmarkEmailValidateToAddress) {
        for (NSString *email in self.toAddresses) {
            if (![SSPostmarkValidators validatesEmail:email type:self.emailFormatType]) {
                SSPostmarkValidationError *error = [SSPostmarkValidationError errorForObject:email failure:1];
                error.instructions = NSLocalizedString(@"Please add a valid email address", nil);
                [self.errorArray addObject:error];
            }
        }
    }
    if (self.validations & SSPostmarkEmailValidateFromAddress) {
        if (!self.fromAddress || ![SSPostmarkValidators validatesEmail:self.fromAddress type:self.emailFormatType]) {
            SSPostmarkValidationError *error = [SSPostmarkValidationError errorForObject:self.fromAddress failure:2];
            error.instructions = NSLocalizedString(@"Please add a valid email address", nil);
            [self.errorArray addObject:error];
        }
    }
    if (self.validations & SSPostmarkEmailValidateCCAddress) {
        for (NSString *email in self.ccAddresses) {
            if (![SSPostmarkValidators validatesEmail:email type:self.emailFormatType]) {
                SSPostmarkValidationError *error = [SSPostmarkValidationError errorForObject:email failure:3];
                error.instructions = NSLocalizedString(@"Please add a valid email address", nil);
                [self.errorArray addObject:error];
            }
        }
    }
    if (self.validations & SSPostmarkEmailValidateBCCAddress) {
        for (NSString *email in self.bccAddresses) {
            if (![SSPostmarkValidators validatesEmail:email type:self.emailFormatType]) {
                SSPostmarkValidationError *error = [SSPostmarkValidationError errorForObject:email failure:4];
                error.instructions = NSLocalizedString(@"Please add a valid email address", nil);
                [self.errorArray addObject:error];
            }
        }
    }
}

- (NSArray *)errors {
    if ([self.errorArray count] == 0) {
        [self _performValidations];
    }
    return [NSArray arrayWithArray:self.errorArray];
}

#pragma mark -
#pragma mark - Lazy Loaders
- (NSMutableArray *)errorArray {
    if (!_errorArray) {
        _errorArray = [NSMutableArray new];
    }
    return _errorArray;
}

- (NSMutableArray *)toAddresses {
    if (!_toAddresses) {
        _toAddresses = [NSMutableArray array];
    }
    return _toAddresses;
}
- (NSMutableArray *)ccAddresses {
    if (!_ccAddresses) {
        _ccAddresses = [NSMutableArray array];
    }
    return _ccAddresses;
}
- (NSMutableArray *)bccAddresses {
    if (!_bccAddresses) {
        _bccAddresses = [NSMutableArray array];
    }
    return _bccAddresses;
}

- (NSMutableArray *)customHeaders {
    if (!_customHeaders) {
        _customHeaders = [NSMutableArray array];
    }
    return _customHeaders;
}

- (NSMutableArray *)attachments {
    if (!_attachments) {
        _attachments = [NSMutableArray array];
    }
    return _attachments;
}

#pragma mark -
#pragma mark - Attachments
- (void)addAttachment:(SSPostmarkAttachment *)attachment {
    [self addAttachments:@[attachment]];
}
- (void)removeAttachment:(SSPostmarkAttachment *)attachment {
    [self removeAttachments:@[attachment]];
}
- (void)addAttachments:(NSArray *)attachments {
    [self.attachments addObjectsFromArray:attachments];
}
- (void)removeAttachments:(NSArray *)attachments {
    [self.attachments removeObjectsInArray:attachments];
}

#pragma mark -
#pragma mark - MetaData
- (void)setValue:(NSString *)value forHeader:(NSString *)header {
    NSAssert(value, @"value is required");
    NSAssert(header, @"header is required");
    [self.customHeaders addObject:@{@"Name": header, @"Value" : value}];
}

#pragma mark -
#pragma mark - API Helper Methods
- (NSDictionary *)asJSONObject {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (self.nameForFromAddress) {
        [dict setValue:[NSString stringWithFormat:@"%@ <%@>",self.nameForFromAddress,self.fromAddress] forKey:@"From"];
    } else {
        [dict setValue:self.fromAddress forKey:@"From"];
    }
    [dict setValue:[self.toAddresses componentsJoinedByString:@","] forKey:@"To"];
    if ([self.ccAddresses count] > 0) {
        [dict setValue:[self.ccAddresses componentsJoinedByString:@","] forKey:@"Cc"];
    }
    if ([self.bccAddresses count] > 0) {
        [dict setValue:[self.bccAddresses componentsJoinedByString:@","] forKey:@"Bcc"];
    }
    if (self.tag) {
        [dict setValue:self.tag forKey:@"Tag"];
    }
    if (self.replyTo) {
        [dict setValue:self.replyTo forKey:@"ReplyTo"];
    } else {
        [dict setValue:self.fromAddress forKey:@"ReplyTo"];
    }
    if (self.subject) {
        [dict setValue:self.subject forKey:@"Subject"];
    }
    if (self.body && [self isHTML]) {
        [dict setValue:self.body forKey:@"HtmlBody"];
    }
    if (self.body && ![self isHTML]) {
        [dict setValue:self.body forKey:@"TextBody"];
    }
    if ([self.customHeaders count] > 0) {
        [dict setValue:self.customHeaders forKey:@"Headers"];
    }
    if ([self.attachments count] > 0) {
        NSMutableArray *attachmentArray = [NSMutableArray new];
        for (SSPostmarkAttachment *attachment in self.attachments) {
            [attachmentArray addObject:[attachment asJSONObject]];
        }
        [dict setValue:attachmentArray forKey:@"Attachments"];
    }
    return dict;
}
- (NSData *)binaryJSON {
    return [NSJSONSerialization dataWithJSONObject:[self asJSONObject] options:0 error:nil];
}

#pragma mark -
#pragma mark - Overrides
- (NSString *)description {
    return [NSString stringWithFormat:@"%@ Tag: \"%@\" Subject: \"%@\" From: \"%@\" To: %@\nBody: %@\nCustom Headers: %@",NSStringFromClass([self class]),self.tag,self.subject,self.fromAddress,self.toAddresses,self.body,self.customHeaders];
}

@end

/*!
 * SSPostmarkResponse.h
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/16/14
 */

#ifndef SSPostmark_SSPostmarkResponse_h
#define SSPostmark_SSPostmarkResponse_h

@import Foundation;

typedef NS_ENUM(NSInteger, SSPostmarkAPIErrorCode) {
    SSPostmarkAPIErrorCodeNone                        = 0,
    SSPostmarkAPIErrorCodeBadToken                    = 10,
    SSPostmarkAPIErrorCodeInvalidEmail                = 300,
    SSPostmarkAPIErrorCodeSenderSignatureNotFound     = 400,
    SSPostmarkAPIErrorCodeSenderSignatureNotConfirmed = 401,
    SSPostmarkAPIErrorCodeIncompatibleJSON            = 402,
    SSPostmarkAPIErrorCodeNotAllowedToSend            = 405,
    SSPostmarkAPIErrorCodeInactiveRecipient           = 406,
    SSPostmarkAPIErrorCodeJSONRequired                = 409,
    SSPostmarkAPIErrorCodeTooManyBatchMessages        = 410,
    SSPostmarkAPIErrorCodeForbiddenAttachmentType     = 411
};

@interface SSPostmarkResponse : NSObject

@property (nonatomic) SSPostmarkAPIErrorCode errorCode;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *messageID;
@property (nonatomic, strong) NSString *submittedAt;

- (NSError *)responseError;

@end

#endif

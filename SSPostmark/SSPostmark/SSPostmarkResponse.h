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

/**
 *  The response from the server.
 */
@interface SSPostmarkResponse : NSObject

/**
 *  The error code returned by the server
 */
@property (nonatomic) SSPostmarkAPIErrorCode errorCode;
/**
 *  The message returned from the server
 */
@property (nonatomic, strong) NSString *info;
/**
 *  The message ID you can use to lookup the message on Postmark
 */
@property (nonatomic, strong) NSString *messageID;
/**
 *  The date the message was submitted as a string.
 */
@property (nonatomic, strong) NSString *submittedAt;

/**
 *  The response error.
 *
 *  This could be either a Cocoa error from the NSURLSession, a SSPostmarkErrorCodePostmarkHTTP or SSPostmarkErrorCodeJSONResponseError 
 *
 *  @return The response error.
 */
- (NSError *)responseError;

@end

#endif

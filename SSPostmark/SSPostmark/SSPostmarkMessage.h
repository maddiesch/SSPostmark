/*!
 * SSPostmarkMessage.h
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/16/14
 */

#ifndef SSPostmark_SSPostmarkMessage_h
#define SSPostmark_SSPostmarkMessage_h

@import Foundation;

/**
 *  A Postmark message object.
 *
 *  This represents an email message you can send to Postmark.
 */
@interface SSPostmarkMessage : NSObject

/**
 *  The email address the message will be sent from.
 */
@property (nonatomic, strong) NSString *fromAddress;
/**
 *  The email address the recipients should reply to.
 */
@property (nonatomic, strong) NSString *replyToAddress;

/**
 *  Email addresses the message will be sent you.
 *
 *  In the form of `user@example.com` | `"User Name" <user@example.com>`
 */
@property (nonatomic, strong) NSSet *toAddresses;
/**
 *  Email addresses to cc on the message.
 *
 *  In the form of `user@example.com` | `"User Name" <user@example.com>`
 */
@property (nonatomic, strong) NSSet *ccAddresses;
/**
 *  Email addresses to bcc on the message. 
 *  
 *  In the form of `user@example.com` | `"User Name" <user@example.com>`
 */
@property (nonatomic, strong) NSSet *bccAddresses;

/**
 *  A set of `SSPostmarkHeaderItem` objects to include in the request
 */
@property (nonatomic, strong) NSSet *additionalHeaders;

/**
 *  a set of `SSPostmarkMessageAttachment` objects to include in the request.
 */
@property (nonatomic, strong) NSSet *attachments;

/**
 *  The message subject
 */
@property (nonatomic, strong) NSString *subject;
/**
 *  HTML body of the message.
 */
@property (nonatomic, strong) NSString *HTMLBody;
/**
 *  Text body of the message.
 */
@property (nonatomic, strong) NSString *textBody;

/**
 *  Postmark tag
 */
@property (nonatomic, strong) NSString *tag;
/**
 *  Postmark will track email opens
 */
@property (nonatomic) BOOL trackOpens;

/**
 *  Check if a message is valid.  This checks if all the parameters are correct.
 *
 *  @return YES/NO of message validity
 */
- (BOOL)isValid;

@end

#endif

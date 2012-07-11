//
//  SSPostmarkMessage.h
//  SSPostmark
//
//  Created by Skylar Schipper on 7/10/12.
//  Copyright (c) 2012 Schipper Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSPostmark_Helper.h"
#import "SSPostmarkAttachment.h"

/**
 SSPostmarkMessage contains all the information that Postmark needs to send an email.
 */
@interface SSPostmarkMessage : NSObject
@property (nonatomic, retain) NSString *apiKey;

/** The HTML formatted body of the email
 
 This will send as HTML to the email recipient.  Any valid HTML is okay.
 
 ___Required___
 
 */
@property (nonatomic, retain) NSString *htmlBody;

/** The plain text to send in the email
 
 This will be sent as plain text to the recipient.  It's important to note that some email clients will automaticaly parse links/email addresses found in plan text, but this behavior should not be counted on.
 
 ___Required___
 
 */
@property (nonatomic, retain) NSString *textBody;

/** The email address that the email will be sent from.
 
 This needs to be vaild Postmark sender email address.  If it's not Postmark will return a `400 – Sender signature not found` or `401 – Sender signature not confirmed`
 
 ___Required___
 
 */
@property (nonatomic, retain) NSString *fromEmail;

/** Who you want to recive the email
 
 This email will not be vaildated before sending.  You should handle this with SSPostmark isValidEmail:
 
 Separate multiple addressess using commas.
 
 > [http://developer.postmarkapp.com/developer-build.html](http://developer.postmarkapp.com/developer-build.html) : You can pass multiple recipient addresses in the ‘To’ field and the optional ‘Cc’ and ‘Bcc’ fields. Separate multiple addresses with a comma. Note that Postmark has a limit of twenty recipients per message in total. You need to take care not to exceed that limit. Otherwise you will get an error.
 
 ___Required___
 
 */
@property (nonatomic, retain) NSString *to;

/** Email Subject
 
 This should be a plain text string.
 
 ___Required___
 
 */
@property (nonatomic, retain) NSString *subject;

/** The tag for Postmark Statistics
 
 ___Required___
 
 */
@property (nonatomic, retain) NSString *tag;

/** Email to reply to.
 
 If the recipient uses a "Reply" button in their email program to.
 
 ___Required___
 
 */
@property (nonatomic, retain) NSString *replyTo;

/** Email Addresses for the CC: field.
 
 This email will not be vaildated before sending.  You should handle this with SSPostmark isValidEmail:
 
 Separate multiple addressess using commas.
 
 > [http://developer.postmarkapp.com/developer-build.html](http://developer.postmarkapp.com/developer-build.html) : You can pass multiple recipient addresses in the ‘To’ field and the optional ‘Cc’ and ‘Bcc’ fields. Separate multiple addresses with a comma. Note that Postmark has a limit of twenty recipients per message in total. You need to take care not to exceed that limit. Otherwise you will get an error.
 
 */
@property (nonatomic, retain) NSString *cc;

/** Email Addresses for the BCC: field.
 
 This email will not be vaildated before sending.  You should handle this with SSPostmark isValidEmail:
 
 Separate multiple addressess using commas.
 
 > [http://developer.postmarkapp.com/developer-build.html](http://developer.postmarkapp.com/developer-build.html) : You can pass multiple recipient addresses in the ‘To’ field and the optional ‘Cc’ and ‘Bcc’ fields. Separate multiple addresses with a comma. Note that Postmark has a limit of twenty recipients per message in total. You need to take care not to exceed that limit. Otherwise you will get an error.
 
 */
@property (nonatomic, retain) NSString *bcc;

/** Custom Headers for email.
 
 Use Key : Value of `NSDictionary` to set custom email headers.
 */
@property (nonatomic, retain) NSDictionary *headers;

/** An NSArray of SSPostmarkAttachment
 
 To add an attachemnt use addAttachment:
 */
@property (nonatomic, retain) NSArray *attachments;

/** Add SSPostmarkAttachment to the message
 
 @parms attachment A instance of SSPostmarkAttachment
 */
- (void)addAttachment:(SSPostmarkAttachment *)attachment;

/** Validates the SSPostmarkMessage
 
 @return Valid Boolean
 
 */
- (BOOL)isValid;

/** The SSPostmarkMessage as a `NSDictionary` object.
 
 @return An `NSDictionary` representation of the SSPostmarkMessage
 
 */
- (NSDictionary *)asDict;


@end
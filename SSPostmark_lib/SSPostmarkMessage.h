/***
 *    SSPostmark
 *    @author - Skylar Schipper
 *	   @copyright - (2011 - 2012) (c) Skylar Schipper
 *			(All rights reserved)
 *
 *    SSPostmarkMessage.h
 *    7/10/12
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
- (NSDictionary *)dictionaryRepresentation;


@end
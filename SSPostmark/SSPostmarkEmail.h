/***
 *    SSPostmark
 *    @author - Skylar Schipper
 *	   @copyright - (2011 - 2013) (c) Skylar Schipper
 *			(All rights reserved)
 *
 *    SSPostmarkEmail.h
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

#import <Foundation/Foundation.h>
#import "SSPostmarkValidators.h"
#import "SSPostmarkAttachment.h"

/** The email object that represents a Postmark Email
 
 */
@interface SSPostmarkEmail : NSObject

/** Who to send the email to
 
 An array of people to send the emails to.
 */
@property (nonatomic, strong) NSMutableArray *toAddresses;

/** Who to send a cc copy of the email to.
 
 */
@property (nonatomic, strong) NSMutableArray *ccAddresses;

/** Who to send a bcc copy of the email to.
 
 */
@property (nonatomic, strong) NSMutableArray *bccAddresses;

/** Who the email is coming from
 
 The array of addresses who the email is coming from
 */
@property (nonatomic, strong) NSString *fromAddress;
/** The display name for the from email address
 
 */
@property (nonatomic, strong) NSString *nameForFromAddress;

/** Email address recipient should reply to
 
 If none is set the value in fromAddress will be used
 */
@property (nonatomic, strong) NSString *replyTo;

/** The subject line for the email
 
 */
@property (nonatomic, strong) NSString *subject;

/** The email body
 
 Can be either plain text or HTML
 */
@property (nonatomic, strong) NSString *body;

/** Indicates if the message body is in HTML
 
 */
@property (nonatomic, getter = isHTML) BOOL html;

/** Used to set the email body and html flag at the same time
 
 @param body Sets the body property
 
 @param isHTML Sets the html property
 */
- (void)setBody:(NSString *)body isHTML:(BOOL)isHTML;

#pragma mark -
#pragma mark - Attachments

/** Add a SSPostmarkAttachment to an email
 
 @param attachment A valid SSPostmarkAttachment object
 */
- (void)addAttachment:(SSPostmarkAttachment *)attachment;

/** Remove an attachment from the email

 @param attachment A valid SSPostmarkAttachment object
 */
- (void)removeAttachment:(SSPostmarkAttachment *)attachment;

/** Add multiple attachments

 @param attachments An array of SSPostmarkAttachment objects
 */
- (void)addAttachments:(NSArray *)attachments;

/** Remove the passed attachments from the email

 @param attachments An array of SSPostmarkAttachment objects
 */
- (void)removeAttachments:(NSArray *)attachments;

#pragma mark -
#pragma mark - Metadata
/** The tag for the message
 
 Used by Postmark to organize messages on the dashboard
 */
@property (nonatomic, strong) NSString *tag;

/** Set a value for a custom header
 
 Used by the Postmark API
 
 @param value The value to set for the name
 
 @param header The header name
 
 @warning This does not set any values for the HTTP request
 */
- (void)setValue:(NSString *)value forHeader:(NSString *)header;

#pragma mark -
#pragma mark - Validations
/** Validations to perform on the email
 
 Defined in SSPostmarkValidators.h
 */
@property (nonatomic) SSPostmarkEmailValidations validations;

/** Type of email validation to use
 
 Defaults to Strict
 */
@property (nonatomic) SSPostmarkEmailAddressValidationType emailFormatType;

/** Returns any email errors
 
 @return An array of SSPostmarkValidatonError objects
 
 */
- (NSArray *)errors;

/** Returns a boolean if any validation errors were raised
 
 @return A boolean indicating if there are any validation errors
 */
- (BOOL)isValid;

#pragma mark -
#pragma mark - API Helper Methods
- (NSDictionary *)asJSONObject;
- (NSData *)binaryJSON;

@end

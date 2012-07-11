/***
 *    SSPostmark
 *    @author - Skylar Schipper
 *	   @copyright - (2011 - 2012) (c) Skylar Schipper
 *			(All rights reserved)
 *
 *    SSPostmark.h
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

#import <Foundation/Foundation.h>

#ifndef __IPHONE_5_0
    #warning "This project uses NSJSONSerialization.  Only available in iOS >= 5.0"
#endif

#define __deprecated__ __attribute__((deprecated))

/**
 *
 *  Notification Center Callbacks
 *
 */
#define pm_POSTMARK_NOTIFICATION @"com.sspostmark.response"

/**
 *
 *  Keys for the NSDictionary Items
 *
 *
 */
static const NSString *kSSPostmarkHTMLBody = @"HtmlBody"; // Expects NSString
static const NSString *kSSPostmarkTextBody = @"TextBody"; // Expects NSString
static const NSString *kSSPostmarkFrom = @"From"; // Expects NSString
static const NSString *kSSPostmarkTo = @"To"; // Expects NSString
static const NSString *kSSPostmarkCC = @"Cc"; // Expects NSString :: OPTIONAL
static const NSString *kSSPostmarkBCC = @"Bcc"; // Expects NSString :: OPTIONAL
static const NSString *kSSPostmarkSubject = @"Subject"; // Expects NSString
static const NSString *kSSPostmarkTag = @"Tag"; // Expects NSString
static const NSString *kSSPostmarkReplyTo = @"ReplyTo"; // Expects NSString
static const NSString *kSSPostmarkHeaders = @"Headers";// Expects NSDictionary :: OPTIONAL

// See http://developer.postmarkapp.com/developer-build.html#attachments
static const NSString *kSSPostmarkAttachments = @"Attachments";// :: OPTIONAL :: Expects NSArray of NSDictionaries with the following attachment keys
static const NSString *kSSPostmarkAttachmentName = @"Name";// Expects NSString
static const NSString *kSSPostmarkAttachmentContent = @"Content";// Expects Base64-encoded binary content as an NSString
static const NSString *kSSPostmarkAttachmentContentType = @"ContentType";// Expects NSString
/**
 *
 *  Response Keys
 *      The parsed JSON dictionary should contain these keys
 */
static const NSString *kSSPostmarkResp_ErrorCode = @"";
static const NSString *kSSPostmarkResp_Message = @"Message";
static const NSString *kSSPostmarkResp_MessageID = @"MessageID";
static const NSString *kSSPostmarkResp_SubmittedAt = @"SubmittedAt";
static const NSString *kSSPostmarkResp_To = @"To";

// Forward Declaration of delegate
@protocol SSPostmarkDelegate;
@class SSPostmarkMessage;
@class SSPostmarkAttachment;

// Errors
// check out http://developer.postmarkapp.com/developer-build.html for more info
typedef enum {
    SSPMError_NoError = 0,
    SSPMError_IvalidEmailRequest = 300,
    SSPMError_SenderSignatureNotFound = 400,
    SSPMError_SenderSignatureNotConfirmed = 401,
    SSPMError_InvalidJSON = 402,
    SSPMError_IncompatiableJSON = 403,
    SSPMError_NotAllowedToSend = 405,
    SSPMError_InactiveRecipient = 406,
    SSPMError_BounceNotFound = 407,
    SSPMError_JSONRequired = 409,
    SSPMError_TooManyBatchMessages = 410,
    SSPMError_Unknown,
    SSPMError_BadMessageDict,
    SSPMErrorNotFound = NSNotFound,
} SSPMErrorType;

typedef void (^SSPostmarkCompletionHandler)(NSDictionary *postmarkResponse, SSPMErrorType errorType);


#pragma mark - Begin SSPostmark Def
/**
 > [Postmark](http://postmarkapp.com/) removes the headaches of delivering and parsing transactional email for webapps with minimal setup time and zero maintenance. We have years of experience getting email to the inbox, so you can work and rest easier.
 
 This is a simple Objective-C class to send email using the Postmark API.
 
 Works on both Mac OS X 10.7 & iOS 5
 */
@interface SSPostmark : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

/** Your API key.
 
 This is required to talk to the Postmark API.  If you don't know your api key it can be found by going to [https://postmarkapp.com/servers](https://postmarkapp.com/servers).  Select the server who you want to send through and then select __Credentials__.
 */
@property (nonatomic, retain) NSString *apiKey;

/** Where to call delegate methods.
 
 In for the most part you should be using the block based API.
 */
@property (nonatomic, assign) id <SSPostmarkDelegate> delegate;

/** Called when Postmark returns a response.
 
 This block is declared as `typedef void (^SSPostmarkCompletionHandler)(NSDictionary *postmarkResponse, SSPMErrorType errorType);`
 
 The `postmarkResponse` should contain keys
 
 - `ErrorCode`
 
 - `Message`
 
 - `MessageID`
 
 - `SubmittedAt`
 
 - `To`
 
 */
@property (nonatomic, copy) SSPostmarkCompletionHandler completion;

#pragma mark 

/**
 
 Returns a SSPostmark initalized with the passed API Key
 
 @param apiKey The Postmark API key for authenticating with Postmark's servers
 
 @return SSPostmark instance
 
 */
- (id)initWithApiKey:(NSString *)apiKey;

- (void)sendEmailWithParamaters:(NSDictionary *)params asynchronously:(BOOL)async __deprecated__;
- (void)sendEmailWithParamaters:(NSDictionary *)params __deprecated__;

/** Send an SSPostmarkMessage to the server
 
 This will ensure the message is valid, then send it to Postmark asynchronously.
 
 @param message A vaild SSPostmarkMessage
 
 */
- (void)sendMessage:(SSPostmarkMessage *)message;

/** Send an SSPostmarkMessag to the server
 
 This will ensure the message is valid, then send it to Postmark asynchronously. When Postmark returns it will call the `completion` block.
 
 @param message A vaild SSPostmarkMessage
 
 @param completion Set the `SSPostmarkCompletionHandler` for the request
 
 */
- (void)sendMessage:(SSPostmarkMessage *)message withCompletion:(SSPostmarkCompletionHandler)completion;

/** Send batch messages to Postmark
 
 Each SSPostmarkMessage will be validated then added to the Postmark request. Once all messages are encoeded it will send the request asynchronously to the Postmark Servers.
 
 @param messages An NSArray of SSPostmarkMessage 
 
 */
- (void)sendBatchMessages:(NSArray *)messages;

/** Send batch messages to Postmark
 
 Each SSPostmarkMessage will be validated then added to the Postmark request. Once all messages are encoeded it will send the request asynchronously to the Postmark Servers.  When Postmark returns it will call the `completion` block.
 
 @param messages An NSArray of SSPostmarkMessage
 
 @param completion Set the `SSPostmarkCompletionHandler` for the request
 
 */
- (void)sendBatchMessages:(NSArray *)messages withCompletion:(SSPostmarkCompletionHandler)completion;


/** Checks if a email address is in a vaild format.
 
 This pregmatches the passed email address
 
 @param email The string to vaildate as an email address
 
 @return email vaildation BOOL
 */
+ (BOOL)isValidEmail:(NSString *)email;

/** Send a message
 
 Class method for quickley sending a SSPostmarkMessage
 
 @param message A vaild SSPostmark instance
 
 @param apiKey Your Postmark API key
 
 @param completion Set the `SSPostmarkCompletionHandler` for the request
 
 */
+ (void)sendMessage:(SSPostmarkMessage *)message apiKey:(NSString *)apiKey completion:(SSPostmarkCompletionHandler)completion;

@end


/** Delegate Methods
 
 You should probably use blocks as these will eventualy be deprecated.
 
 */
@protocol SSPostmarkDelegate <NSObject>

@optional

/** Postmark returned a message
 */
-(void)postmark:(id)postmark returnedMessage:(NSDictionary *)message withStatusCode:(NSUInteger)code;

/** Postmark returned an error
 */
-(void)postmark:(id)postmark encounteredError:(SSPMErrorType)type message:(NSString *)message;

@end


#pragma mark - Begin SSPostmarkMessage Def
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


/**
 SSPostmarkAttachment takes an properly formats data to add as an attachment to an SSPostmarkMessage
 
 See [http://developer.postmarkapp.com/developer-build.html#attachments](http://developer.postmarkapp.com/developer-build.html#attachments) for more info on attachments.
 
 */
@interface SSPostmarkAttachment : NSObject

/** The name of the file being added.
 
 This should include a file extension.
 */
@property (nonatomic, strong) NSString *name;

/** Base64 encoded data.
 
 If you use teh addData: method SSPostmarkAttachment will properly encode the data for you.
 */
@property (nonatomic, strong) NSString *content;

/** The MIME type for the data.
 
 If you don't explicitly set this it will default to `application/octet-stream`.
 */
@property (nonatomic, strong) NSString *contentType;

/** Add NSData object for the attachment
 
 This will automaticaly be converted into a base64 string.
 
 @param data The data for the attachment.
 */
- (void)addData:(NSData *)data;

/** Get the attachment as an `NSDictionary`
 
 @return A dictionary representation for the attachment.
 */
- (NSDictionary *)dictionaryRepresentation;

/** Convenience method
 
 Quick way to get a SSPostmarkAttachment instance
 
 @param content NSData of the attachment data
 
 @param contentType NSString or nil.
 
 @param name The name of the image.
 
 @return An initiated SSPostmarkAttachment object
 
 */
+ (SSPostmarkAttachment *)attachmentWithData:(NSData *)content contentType:(NSString *)contentType name:(NSString *)name;


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR // This keeps support for Mac OS X

/** Convenience method
 
 Quick way to get a SSPostmarkAttachment instance
 
 @param image UIImage to add to the attachment
 
 @param name The name of the image.
 
 @return An initiated SSPostmarkAttachment object
 
 */
+ (SSPostmarkAttachment *)attachmentWithImage:(UIImage *)image name:(NSString *)name;

/** Add UIImage
 
 A convenience method for adding a `UIImage`
 
 @param image The UIImage to add to the attachment
 */
- (void)addImage:(UIImage *)image;
#elif TARGET_OS_MAC

/** Convenience method
 
 Quick way to get a SSPostmarkAttachment instance
 
 @param image NSImage to add to the attachment
 
 @param name The name of the image.
 
 @return An initiated SSPostmarkAttachment object
 
 */
+ (SSPostmarkAttachment *)attachmentWithImage:(NSImage *)image name:(NSString *)name;

/** Add NSImage
 
 A convenience method for adding a `NSImage`
 
 @param image The NSImage to add to the attachment
 */
- (void)addImage:(NSImage *)image;
#endif
@end

#pragma mark - Begin Helper Classes
/**
 *  Base64 encoding
 *
 */
static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

@interface NSData (SSBase64)

- (NSString *)ss_base64String;

@end

//
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

/**
 *
 *  Set async queue name
 *
 */
#define pm_ASYNC_QUEUE_NAME @"com.sspostmark.queue"

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
    SSPMError_APITokenError = 0,
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
@interface SSPostmark : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, retain) NSString *apiKey;
@property (nonatomic, retain) NSString *queueName;
@property (nonatomic, assign) id <SSPostmarkDelegate> delegate;
@property (nonatomic, copy) SSPostmarkCompletionHandler completion;


- (id)initWithApiKey:(NSString *)apiKey;
- (id)initWithApiKey:(NSString *)apiKey queueName:(NSString *)queueName;

- (void)sendEmail:(SSPostmarkMessage *)message;
- (void)sendBatchMessages:(NSArray *)messages;

+ (BOOL)isValidEmail:(NSString *)email;

+ (void)sendMessage:(SSPostmarkMessage *)message withCompletion:(SSPostmarkCompletionHandler)completion;

@end



@protocol SSPostmarkDelegate <NSObject>

// Option Delegate Methods.
    // You should probably use blocks.
@optional
-(void)postmark:(id)postmark returnedMessage:(NSDictionary *)message withStatusCode:(NSUInteger)code;
-(void)postmark:(id)postmark encounteredError:(SSPMErrorType)type;

@end


#pragma mark - Begin SSPostmarkMessage Def
@interface SSPostmarkMessage : NSObject
// Set the Postmark API Key per message.  This doesn't work for batch messages, but for individual messages it sets the Postmark API key befor sending the request.
@property (nonatomic, retain) NSString *apiKey;
// Required
@property (nonatomic, retain) NSString *htmlBody;
@property (nonatomic, retain) NSString *textBody;
@property (nonatomic, retain) NSString *fromEmail;
@property (nonatomic, retain) NSString *to;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *tag;
@property (nonatomic, retain) NSString *replyTo;

// Optional
@property (nonatomic, retain) NSString *cc;
@property (nonatomic, retain) NSString *bcc;
@property (nonatomic, retain) NSDictionary *headers;
@property (nonatomic, retain) NSArray *attachments;

- (void)addAttachment:(SSPostmarkAttachment *)attachment;

- (BOOL)isValid;
- (NSDictionary *)asDict;
@end


@interface SSPostmarkAttachment : NSObject
// Set the name of the file being attached
@property (nonatomic, strong) NSString *name;
// Content is base64 encoded NSData.  Easiest to set this via the addData: method
@property (nonatomic, strong) NSString *content;
// Set the content type Defaults to application/octet-stream
@property (nonatomic, strong) NSString *contentType;

// Helper methods
- (void)addData:(NSData *)data;
- (NSDictionary *)dictionaryRepresentation;

// This keeps support for Mac OS X
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
+ (SSPostmarkAttachment *)attachmentWithImage:(UIImage *)image named:(NSString *)name;
// Add a .png file
- (void)addImage:(UIImage *)image;
#elif TARGET_OS_MAC
+ (SSPostmarkAttachment *)attachmentWithImage:(NSImage *)image named:(NSString *)name;
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

@interface NSData (Base64)

- (NSString *)base64String;

@end
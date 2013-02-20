/***
 *    SSPostmark
 *    @author - Skylar Schipper
 *	   @copyright - (2011 - 2012) (c) Skylar Schipper
 *			(All rights reserved)
 *
 *    SSPostmark_Helper.h
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
#ifndef SSPostmark_SSPostmark_Helper_h
#define SSPostmark_SSPostmark_Helper_h

#ifndef __IPHONE_5_0
#warning "This project uses NSJSONSerialization.  Only available in iOS >= 5.0"
#endif

#ifndef __deprecated__
    #define __deprecated__ __attribute__((deprecated))
#endif

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
static const NSString *kSSPostmarkHTMLBody __attribute__((unused)) = @"HtmlBody"; // Expects NSString
static const NSString *kSSPostmarkTextBody __attribute__((unused)) = @"TextBody"; // Expects NSString
static const NSString *kSSPostmarkFrom     __attribute__((unused)) = @"From"; // Expects NSString
static const NSString *kSSPostmarkTo       __attribute__((unused)) = @"To"; // Expects NSString
static const NSString *kSSPostmarkCC       __attribute__((unused)) = @"Cc"; // Expects NSString :: OPTIONAL
static const NSString *kSSPostmarkBCC      __attribute__((unused)) = @"Bcc"; // Expects NSString :: OPTIONAL
static const NSString *kSSPostmarkSubject  __attribute__((unused)) = @"Subject"; // Expects NSString
static const NSString *kSSPostmarkTag      __attribute__((unused)) = @"Tag"; // Expects NSString
static const NSString *kSSPostmarkReplyTo  __attribute__((unused)) = @"ReplyTo"; // Expects NSString
static const NSString *kSSPostmarkHeaders  __attribute__((unused)) = @"Headers";// Expects NSDictionary :: OPTIONAL

// See http://developer.postmarkapp.com/developer-build.html#attachments
static const NSString *kSSPostmarkAttachments           __attribute__((unused)) = @"Attachments";// :: OPTIONAL :: Expects NSArray of NSDictionaries with the following attachment keys
static const NSString *kSSPostmarkAttachmentName        __attribute__((unused)) = @"Name";// Expects NSString
static const NSString *kSSPostmarkAttachmentContent     __attribute__((unused)) = @"Content";// Expects Base64-encoded binary content as an NSString
static const NSString *kSSPostmarkAttachmentContentType __attribute__((unused)) = @"ContentType";// Expects NSString
/**
 *
 *  Response Keys
 *      The parsed JSON dictionary should contain these keys
 */
static const NSString *kSSPostmarkResp_ErrorCode   __attribute__((unused)) = @"";
static const NSString *kSSPostmarkResp_Message     __attribute__((unused)) = @"Message";
static const NSString *kSSPostmarkResp_MessageID   __attribute__((unused)) = @"MessageID";
static const NSString *kSSPostmarkResp_SubmittedAt __attribute__((unused)) = @"SubmittedAt";
static const NSString *kSSPostmarkResp_To          __attribute__((unused)) = @"To";

// check out http://developer.postmarkapp.com/developer-build.html for more info
typedef enum {
    SSPMError_NoError                     = 0,
    SSPMError_IvalidEmailRequest          = 300,
    SSPMError_SenderSignatureNotFound     = 400,
    SSPMError_SenderSignatureNotConfirmed = 401,
    SSPMError_InvalidJSON                 = 402,
    SSPMError_IncompatiableJSON           = 403,
    SSPMError_NotAllowedToSend            = 405,
    SSPMError_InactiveRecipient           = 406,
    SSPMError_BounceNotFound              = 407,
    SSPMError_JSONRequired                = 409,
    SSPMError_TooManyBatchMessages        = 410,
    SSPMError_Unknown                     = 999,
    SSPMError_BadMessageDict              = 998,
    SSPMErrorNotFound                     = NSNotFound,
} SSPMErrorType;

typedef void (^SSPostmarkCompletionHandler)(NSDictionary *postmarkResponse, SSPMErrorType errorType);

// Default as per http://developer.postmarkapp.com/developer-build.html#attachments
static NSString *_kSSPostmarkDefaultDataType __attribute__((unused)) = @"application/octet-stream";

#endif

//
/***
 *    QuietSight Framework
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
 *  Set your API key
 *
 */
#define pm_YOUR_API_KEY @"POSTMARK_API_TEST"
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
static const NSString* kSSPostmarkHTMLBody = @"HtmlBody"; // Expects NSString
static const NSString* kSSPostmarkTextBody = @"TextBody"; // Expects NSString
static const NSString* kSSPostmarkFrom = @"From"; // Expects NSString
static const NSString* kSSPostmarkTo = @"To"; // Expects NSString
static const NSString* kSSPostmarkCC = @"Cc"; // Expects NSString :: OPTIONAL
static const NSString* kSSPostmarkBCC = @"Bcc"; // Expects NSString :: OPTIONAL
static const NSString* kSSPostmarkSubject = @"Subject"; // Expects NSString
static const NSString* kSSPostmarkTag = @"Tag"; // Expects NSString
static const NSString* kSSPostmarkReplyTo = @"ReplyTo"; // Expects NSString
static const NSString* kSSPostmarkHeaders = @"Headers";// Expects NSDictionary :: OPTIONAL

// Forward Declaration of delegate
@protocol SSPostmarkDelegate;

@interface SSPostmark : NSObject
@property (nonatomic, assign) id <SSPostmarkDelegate> delegate;


-(void)sendEmailWithParamaters:(NSDictionary*)params asynchronously:(BOOL)async;


@end

typedef enum {
    SSPMError_Unknown,
    SSPMError_BadMessageDict,
}SSPMErrorType;

@protocol SSPostmarkDelegate <NSObject>

// Option Delegate Methods
@optional
-(void)postmark:(id)postmark returnedMessage:(NSDictionary*)message withStatusCode:(NSUInteger)code;
-(void)postmark:(id)postmark encounteredError:(SSPMErrorType)type;
@end

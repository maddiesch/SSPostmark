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
#import "SSPostmark_Helper.h"
#import "SSPostmarkMessage.h"
#import "SSPostmarkAttachment.h"

// Forward Declaration of delegate
@protocol SSPostmarkDelegate;


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

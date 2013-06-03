/***
 *    SSPostmark
 *    @author - Skylar Schipper
 *	   @copyright - (2011 - 2013) (c) Skylar Schipper
 *			(All rights reserved)
 *
 *    SSPostmark.h
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

extern NSString * const SSPostmarkAPIErrorDomain;
extern NSString * const SSPostmarkNetworkErrorDomain;

@class SSPostmarkEmail;

/** Used to interface with teh Postmark API
 
 */
@interface SSPostmark : NSObject

/** Your API key.
 
 This is required to talk to the Postmark API.  If you don't know your api key it can be found by going to [https://postmarkapp.com/servers](https://postmarkapp.com/servers).  Select the server who you want to send through and then select __Credentials__.
 */
@property (nonatomic, strong, readonly) NSString *apiKey;


/** Designated Initalizer
 
 Returns a new instance of SSPostmark witht the passed apiKey
 
 @param apiKey The API key used to authenticate with the Postmark API
 
 @return A new SSPostmark instance
 */
- (id)initWithApiKey:(NSString *)apiKey;

#pragma mark -
#pragma mark - Send Email
- (void)sendEmail:(SSPostmarkEmail *)email;
- (void)sendEmail:(SSPostmarkEmail *)email completion:(void(^)(BOOL success, NSError *error))completion;

@end

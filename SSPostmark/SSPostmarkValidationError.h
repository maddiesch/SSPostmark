/***
 *    SSPostmark
 *    @author - Skylar Schipper
 *	   @copyright - (2011 - 2013) (c) Skylar Schipper
 *			(All rights reserved)
 *
 *    SSPostmarkEmailError.h
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

extern NSString * const SSPostmarkValidationEmailError;


/** Email Validation Error
 
 Status Codes
 
 - 1 Invalid to email address
 
 - 2 Invalid from email address
 
 - 3 Invalid cc email address
 
 - 4 Invalid bcc email address
 
 - 100 No to email addresses found
 
 - 101 No from email address found
 
 */
@interface SSPostmarkValidationError : NSError

/** Validation failure
 
 Normally the same as `-[NSError code]`
 */
@property (nonatomic) NSUInteger emailValidationFailure;

/** The object that failed validation
 
 */
@property (nonatomic) id failedValidationObject;

/** Localized string with instructions for making the error pass
 
 */
@property (nonatomic) NSString *instructions;


+ (instancetype)errorForObject:(id)failedObject failure:(NSUInteger)failure;

@end

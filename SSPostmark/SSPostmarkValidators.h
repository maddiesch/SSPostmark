/***
 *    SSPostmark
 *    @author - Skylar Schipper
 *	   @copyright - (2011 - 2013) (c) Skylar Schipper
 *			(All rights reserved)
 *
 *    SSPostmarkValidators.h
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

typedef NS_ENUM(NSUInteger, SSPostmarkEmailAddressValidationType) {
    SSPostmarkEmailAddressValidateStrict = 0,
    SSPostmarkEmailAddressValidateLax    = 1
};

/** Helper class for validation
 
 */
@interface SSPostmarkValidators : NSObject

/** Checks the passed string for valid email format
 
 This does not check if the email *exists*.  It only checks that it is in the correct format.
 
 @param email A NSString containing an email address
 
 @param type The type of validation to perform on the email address
 
 Defined as 
 
    typedef NS_ENUM(NSUInteger, SSPostmarkEmailValidationType) {
        SSPostmarkEmailValidateStrict = 0,
        SSPostmarkEmailValidateLax    = 1
    };
 
 - `SSPostmarkEmailValidateStrict` A more strict email validation method
 
 - `SSPostmarkEmailValidateLax` Very simple validation for an email address
 
 */
+ (BOOL)validatesEmail:(NSString *)email type:(SSPostmarkEmailAddressValidationType)type;

@end

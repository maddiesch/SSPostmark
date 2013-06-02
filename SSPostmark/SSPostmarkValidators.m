/***
 *    SSPostmark
 *    @author - Skylar Schipper
 *	   @copyright - (2011 - 2013) (c) Skylar Schipper
 *			(All rights reserved)
 *
 *    SSPostmarkValidators.m
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

#define EMAIL_STRICT_REGEX @"^[a-zA-Z0-9][A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
#define EMAIL_LAX_REGEX @".+@.+\\.[A-Za-z]{2}[A-Za-z]*"

#import "SSPostmarkValidators.h"

@implementation SSPostmarkValidators

#pragma mark -
#pragma mark - Validation Methods
+ (BOOL)validatesEmail:(NSString *)email type:(SSPostmarkEmailAddressValidationType)type {
    NSAssert(email, @"Must pass an email address");
    if (type == SSPostmarkEmailAddressValidateStrict) {
        return [self _validateStrictEmail:email];
    }
    if (type == SSPostmarkEmailAddressValidateLax) {
        return [self _validateLaxEmail:email];
    }
    return NO;
}

#pragma mark -
#pragma mark - Private Email Validations
+ (BOOL)_validateStrictEmail:(NSString *)email {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",EMAIL_STRICT_REGEX] evaluateWithObject:email];
}
+ (BOOL)_validateLaxEmail:(NSString *)email {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",EMAIL_LAX_REGEX] evaluateWithObject:email];
}

@end

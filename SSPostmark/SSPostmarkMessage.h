// SSPostmarkMessage.h
// 
// Copyright (c) 2012 Skylar Schipper
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
// 
// Redistributions of source code must retain the above copyright notice, this 
// list of conditions and the following disclaimer. Redistributions in binary 
// form must reproduce the above copyright notice, this list of conditions and 
// the following disclaimer in the documentation and/or other materials 
// provided with the distribution. Neither the name of the nor the names of 
// its contributors may be used to endorse or promote products derived from 
// this software without specific prior written permission. 
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
// POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>

NSString static const *kSSPostmarkHTMLBody = @"HtmlBody";
NSString static const *kSSPostmarkTextBody = @"TextBody";
NSString static const *kSSPostmarkFrom     = @"From";
NSString static const *kSSPostmarkTo       = @"To";
NSString static const *kSSPostmarkCC       = @"Cc";
NSString static const *kSSPostmarkBCC      = @"Bcc";
NSString static const *kSSPostmarkSubject  = @"Subject";
NSString static const *kSSPostmarkTag      = @"Tag";
NSString static const *kSSPostmarkReplyTo  = @"ReplyTo";
NSString static const *kSSPostmarkHeaders  = @"Headers";

/** <#Description#>
 
 <#Discussion#>
 
 */
@interface SSPostmarkMessage : NSObject

/** <#Description#>
 
 <#Discussion#>
 
 */
@property (nonatomic, retain) NSString *htmlBody;

/** <#Description#>
 
 <#Discussion#>
 
 */
@property (nonatomic, retain) NSString *textBody;

/** <#Description#>
 
 <#Discussion#>
 
 */
@property (nonatomic, retain) NSString *fromEmail;

/** <#Description#>
 
 <#Discussion#>
 
 */
@property (nonatomic, retain) NSString *to;

/** <#Description#>
 
 <#Discussion#>
 
 */
@property (nonatomic, retain) NSString *subject;

/** <#Description#>
 
 <#Discussion#>
 
 */
@property (nonatomic, retain) NSString *tag;

/** <#Description#>
 
 <#Discussion#>
 
 */
@property (nonatomic, retain) NSString *replyTo;

/** <#Description#>
 
 <#Discussion#>
 
 */
@property (nonatomic, retain) NSString *cc;

/** <#Description#>
 
 <#Discussion#>
 
 */
@property (nonatomic, retain) NSString *bcc;

/** <#Description#>
 
 <#Discussion#>
 
 */
@property (nonatomic, retain) NSDictionary *headers;

/** <#Description#>
 
 <#Discussion#>
 
 */
//@property (nonatomic, retain) NSArray *attachments;

#pragma mark - Setup the request
/** <#Description#>
 
 <#Discussion#>
 
 */
- (NSData *)body;
/** <#Description#>
 
 <#Discussion#>
 
 */
@property (nonatomic, readonly, getter = isValid) BOOL valid;

@end

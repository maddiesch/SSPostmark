// SSPostmarkAttachment.h
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

NSString static const *kSSPostmarkAttachmentName        = @"Name";
NSString static const *kSSPostmarkAttachmentContent     = @"Content";
NSString static const *kSSPostmarkAttachmentContentType = @"ContentType";

#ifdef TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
typedef UIImage SSPMImage;
#else
typedef NSImage SSPMImage;
#endif

typedef NS_ENUM(NSUInteger, SSPMImageType) {
    SSPMImageTypePNG = 0,
    SSPMImageTypeJPEG = 1,
};

@interface SSPostmarkAttachment : NSObject

/** <#Description#>
 
 <#Discussion#>
 
 */
@property (nonatomic, strong) NSString *name;

/** <#Description#>
 
 <#Discussion#>
 
 */
@property (nonatomic, strong) NSData *content;

/** <#Description#>
 
 <#Discussion#>
 
 */
@property (nonatomic, strong) NSString *contentType;

/** <#Description#>
 
 <#Discussion#>
 
 */
- (NSDictionary *)dictionary;

+ (instancetype)attachmentWithImage:(SSPMImage *)image name:(NSString *)name type:(SSPMImageType)type;

@end

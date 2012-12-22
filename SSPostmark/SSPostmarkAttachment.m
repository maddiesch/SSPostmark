// SSPostmarkAttachment.m
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

#import "SSPostmarkAttachment.h"

@implementation SSPostmarkAttachment

#pragma mark -
#pragma mark -
- (NSString *)contentType {
    if (_contentType == nil || [_contentType isEqualToString:@""]) {
        return @"application/octet-stream";
    }
    return _contentType;
}

#pragma mark -
#pragma mark -
- (NSString *)base64Body {
    if (self.content == nil) {
        return @"";
    }
    static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    const unsigned char * rawData = [self.content bytes];
    char * objPointer;
    char * strResult;
    
    NSUInteger intLength = [self.content length];
    if (intLength == 0)
        return nil;
    
    strResult = (char *)calloc(((intLength + 2) / 3) * 4, sizeof(char));
    objPointer = strResult;
    
    while (intLength > 2) {
        *objPointer++ = _base64EncodingTable[rawData[0] >> 2];
        *objPointer++ = _base64EncodingTable[((rawData[0] & 0x03) << 4) + (rawData[1] >> 4)];
        *objPointer++ = _base64EncodingTable[((rawData[1] & 0x0f) << 2) + (rawData[2] >> 6)];
        *objPointer++ = _base64EncodingTable[rawData[2] & 0x3f];
        rawData += 3;
        intLength -= 3;
    }
    
    if (intLength != 0) {
        *objPointer++ = _base64EncodingTable[rawData[0] >> 2];
        if (intLength > 1) {
            *objPointer++ = _base64EncodingTable[((rawData[0] & 0x03) << 4) + (rawData[1] >> 4)];
            *objPointer++ = _base64EncodingTable[(rawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = _base64EncodingTable[(rawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    *objPointer = '\0';
    NSString *retVal = [[NSString alloc] initWithCString:strResult encoding:NSASCIIStringEncoding];
    free(strResult);
    return retVal;
}

#pragma mark -
#pragma mark -
- (NSDictionary *)dictionary {
    return (@{
            kSSPostmarkAttachmentContent : [self base64Body],
            kSSPostmarkAttachmentContentType : self.contentType,
            kSSPostmarkAttachmentName : self.name
            });
}

#pragma mark -
#pragma mark - Helper Methods
+ (instancetype)attachmentWithImage:(SSPMImage *)image name:(NSString *)name type:(SSPMImageType)type {
    SSPostmarkAttachment *att = [[SSPostmarkAttachment alloc] init];
    att.name = name;
    if (type == SSPMImageTypePNG) {
        att.content = [[self class] _dataWithPNG:image];
    }
    return att;
}

+ (NSData *)_dataWithPNG:(SSPMImage *)image {
#ifdef TARGET_OS_IPHONE
    return UIImagePNGRepresentation(image);
#else
    
#endif
}

@end

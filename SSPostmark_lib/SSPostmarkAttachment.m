/***
 *    SSPostmark
 *    @author - Skylar Schipper
 *	   @copyright - (2011 - 2012) (c) Skylar Schipper
 *			(All rights reserved)
 *
 *    SSPostmarkAttachment.m
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


#import "SSPostmarkAttachment.h"


@interface SSPostmarkAttachment ()

- (void)ss_addImage:(id)image;

@end

@implementation SSPostmarkAttachment

- (void)addData:(NSData *)data {
    _content = [data ss_base64String];
}

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
- (void)addImage:(UIImage *)image {
    [self ss_addImage:image];
}
#elif TARGET_OS_MAC
- (void)addImage:(NSImage *)image {
    [self ss_addImage:image];
}
#endif

- (void)ss_addImage:(id)image {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    [self addData:UIImagePNGRepresentation((UIImage *)image)];
#elif TARGET_OS_MAC
    NSImage *img = (NSImage *)image;
    [img lockFocus];
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, img.size.width, img.size.height)];
    [img unlockFocus];
    [self addData:[bitmapRep representationUsingType:NSPNGFileType properties:nil]];
#endif
    if ([self.name length]) {
        if (![self.name hasSuffix:@".png"]) {
            self.name = [NSString stringWithFormat:@"%@.png",self.name];
        }
    } else {
        self.name = NSLocalizedString(@"image.png", @"default image name");
    }
}

- (NSDictionary *)dictionaryRepresentation {
	return @{
        kSSPostmarkAttachmentContent: self.content,
        kSSPostmarkAttachmentContentType: self.contentType,
        kSSPostmarkAttachmentName: self.name
    };
}

- (id)init {
    self = [super init];
    if (self) {
        _contentType = _kSSPostmarkDefaultDataType;
    }
    return self;
}

+ (SSPostmarkAttachment *)attachmentWithData:(NSData *)content contentType:(NSString *)contentType name:(NSString *)name {
    SSPostmarkAttachment *att = [[self alloc] init];
    att.name = name;
	att.contentType = contentType;
	[att addData:content];
    return att;
}

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
+ (SSPostmarkAttachment *)attachmentWithImage:(UIImage *)image name:(NSString *)name {
    SSPostmarkAttachment *att = [[self alloc] init];
    att.name = name;
    [att addImage:image];
    return att;
}
#elif TARGET_OS_MAC
+ (SSPostmarkAttachment *)attachmentWithImage:(NSImage *)image name:(NSString *)name {
    SSPostmarkAttachment *att = [[self alloc] init];
    att.name = name;
    [att addImage:image];
    return att;
}
#endif

- (void)setContentType:(NSString *)contentType {
    if (contentType == nil) {
        _contentType = @"application/octet-stream";
        return;
    }
    _contentType = contentType;
}


@end




#pragma mark - SSPostmarkAttachment


@implementation NSData (SSBase64)

- (NSString *)ss_base64String {
    const unsigned char * rawData = [self bytes];
    char * objPointer;
    char * strResult;
    
    NSUInteger intLength = self.length;
    if (intLength == 0) return nil;
    
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

@end
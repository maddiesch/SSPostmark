/*!
 * SSPostmarkMessageAttachment.m
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/17/14
 */

#import "SSPostmarkMessageAttachmentPrivate.h"

@interface SSPostmarkMessageAttachment ()

@end

@implementation SSPostmarkMessageAttachment

- (NSDictionary *)JSONRepresentation {
    return @{
             @"Name": self.filename,
             @"Content": [self base64EncodedData],
             @"ContentType": self.contentType
             };
}
- (NSString *)base64EncodedData {
    if (!self.fileData) {
        return nil;
    }
    return [self.fileData base64EncodedStringWithOptions:0];
}

- (NSString *)contentType {
    if (!_contentType) {
        _contentType = [self.class contentTypeForFileExtension:[self.filename pathExtension]];
    }
    return _contentType;
}
- (NSData *)fileData {
    if (!_fileData) {
        if (self.fileURL) {
            _fileData = [NSData dataWithContentsOfURL:self.fileURL];
        }
    }
    return _fileData;
}

+ (NSString *)contentTypeForFileExtension:(NSString *)fileExt {
    static NSString *const octetStream = @"application/octet-stream";
    if (!fileExt) {
        return octetStream;
    }
    
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExt, NULL);
    CFStringRef mimeType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
    
    if (mimeType != NULL) {
        return (__bridge_transfer id)mimeType;
    }
    return octetStream;
}

@end

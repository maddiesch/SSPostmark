//
//  SSPostmarkAttachment.m
//  SSPostmark
//
//  Created by Skylar Schipper on 6/2/13.
//  Copyright (c) 2013 Skylar Schipper. All rights reserved.
//

#import "SSPostmarkAttachment.h"

@implementation SSPostmarkAttachment

+ (NSArray *)allowedAttachmentExtensions {
    return @[@"gif",@"jpeg",@"png",@"swf",@"dcr",@"tiff",@"bmp",@"ico",@"page-icon",@"wav",@"mp3",@"flv",@"avi",@"mpg",@"wmv",@"rm",@"mov",@"3gp",@"mp4",@"m4a",@"ogv",@"wma",@"svg",@"txt",@"rtf",@"html",@"xml",@"ics",@"pdf",@"log",@"csv",@"docx",@"dotx",@"pptx",@"xlsx",@"odt",@"psd",@"ai",@"vcf",@"mobi",@"epub",@"pgp",@"ods",@"wps",@"pages",@"stl",@"ppt",@"xls",@"doc",@"dat",@"pkpass",@"mms",@"mmr",@"json",@"pcm",@"mpp",@"mppx",@"prn",@"eps",@"license",@"zip",@"dcm",@"enc",@"cdr",@"css",@"pst",@"mobileconfig",@"eml",@"gpx",@"kml",@"kmz",@"msl",@"rb",@"js",@"java",@"c",@"cpp",@"py",@"php",@"fl",@"jar",@"ttf",@"vpv",@"iif",@"timo",@"autorit",@"cathodelicense",@"itn",@"freshroute"];
}
+ (BOOL)nameIsAllowed:(NSString *)name {
    return [[NSPredicate predicateWithFormat:@"pathExtension IN (%@)",[self allowedAttachmentExtensions]] evaluateWithObject:name];
}

- (id)init {
    self = [super init];
    if (self) {
        _contentType = @"application/octet-stream";
    }
    return self;
}

#pragma mark -
#pragma mark - Custom Setters
- (void)setName:(NSString *)name {
    if (![[self class] nameIsAllowed:name]) {
        [NSException raise:SSPostmarkAttachmentInvalidNameException format:@"%@ has an invalid file extention",name];
    }
    [self willChangeValueForKey:@"name"];
    _name = name;
    [self didChangeValueForKey:@"name"];
}
- (void)setContentData:(NSData *)data {
    self.content = [[self class] base64EndcodeData:data];
}

#pragma mark -
#pragma mark - Helpers
+ (NSString *)base64EndcodeData:(NSData *)data {
    const char SSPostmarkBase64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    const unsigned char * objRawData = [data bytes];
    char * objPointer;
    char * strResult;
    NSUInteger intLength = [data length];
    if (intLength == 0) return nil;
    strResult = (char *)calloc(((intLength + 2) / 3) * 4, sizeof(char));
    objPointer = strResult;
    while (intLength > 2) {
        *objPointer++ = SSPostmarkBase64EncodingTable[objRawData[0] >> 2];
        *objPointer++ = SSPostmarkBase64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
        *objPointer++ = SSPostmarkBase64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
        *objPointer++ = SSPostmarkBase64EncodingTable[objRawData[2] & 0x3f];
        objRawData += 3;
        intLength -= 3;
    }
    if (intLength != 0) {
        *objPointer++ = SSPostmarkBase64EncodingTable[objRawData[0] >> 2];
        if (intLength > 1) {
            *objPointer++ = SSPostmarkBase64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
            *objPointer++ = SSPostmarkBase64EncodingTable[(objRawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = SSPostmarkBase64EncodingTable[(objRawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    *objPointer = '\0';
    NSString *retVal = [[NSString alloc] initWithCString:strResult encoding:NSASCIIStringEncoding];
    free(strResult);
    return retVal;
}

#if TARGET_OS_IPHONE

+ (instancetype)attachmentWithImage:(UIImage *)image name:(NSString *)name {
    if (![[name pathExtension] isEqualToString:@"png"] || ![[name pathExtension] isEqualToString:@"jpeg"]) {
        return nil;
    }
    NSData *imageData = nil;
    NSString *MIMEType = nil;
    if ([[name pathExtension] isEqualToString:@"png"]) {
        imageData = UIImagePNGRepresentation(image);
        MIMEType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 8.0);
        MIMEType = @"image/jpeg";
    }
    if (!imageData) {
        return nil;
    }
    
    SSPostmarkAttachment *attachment = [[SSPostmarkAttachment alloc] init];
    attachment.name = name;
    attachment.contentType = MIMEType;
    [attachment setContentData:imageData];
    return attachment;
}

#endif

#pragma mark -
#pragma mark - API Helper Methods
- (NSDictionary *)asJSONObject {
    return @{@"Name": self.name, @"Content": self.content, @"ContentType": self.contentType};
}
- (NSData *)binaryJSON {
    return [NSJSONSerialization dataWithJSONObject:[self asJSONObject] options:0 error:nil];
}

@end

NSString * const SSPostmarkAttachmentInvalidNameException = @"SSPostmarkAttachmentInvalidNameException";

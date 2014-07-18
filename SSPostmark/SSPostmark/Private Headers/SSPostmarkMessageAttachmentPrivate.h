//
//  SSPostmarkMessageAttachmentPrivate.h
//  SSPostmark
//
//  Created by Skylar Schipper on 7/17/14.
//  Copyright (c) 2014 OpenSky, LLC. All rights reserved.
//

#ifndef SSPostmark_SSPostmarkMessageAttachmentPrivate_h
#define SSPostmark_SSPostmarkMessageAttachmentPrivate_h

#import "SSPostmarkMessageAttachment.h"

@interface SSPostmarkMessageAttachment (PrivateMethods)

- (NSDictionary *)JSONRepresentation;
- (NSString *)base64EncodedData;

+ (NSString *)contentTypeForFileExtension:(NSString *)fileExt;

@end

#endif

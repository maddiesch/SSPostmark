/*!
 * SSPostmarkMessageAttachment.h
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/17/14
 */

#ifndef SSPostmark_SSPostmarkMessageAttachment_h
#define SSPostmark_SSPostmarkMessageAttachment_h

@import Foundation;
@import MobileCoreServices;

@interface SSPostmarkMessageAttachment : NSObject

@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *contentType;

@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) NSData *fileData;

@end

#endif

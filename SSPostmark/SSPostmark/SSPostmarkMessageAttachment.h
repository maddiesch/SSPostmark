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

/**
 *  Postmark allows you to send up to 10MB of attachments with each message.
 */
@interface SSPostmarkMessageAttachment : NSObject

/**
 *  The name of the file to use for the message attachment.
 *
 *  If a `contentType` isn't explicitly set the filename path extension will be used to generate an appropriate contentType
 */
@property (nonatomic, strong) NSString *filename;
/**
 *  The MIME type for the attachment file.  This can be inferred from the filename extension
 */
@property (nonatomic, strong) NSString *contentType;

/**
 *  The NSURL to the file
 */
@property (nonatomic, strong) NSURL *fileURL;
/**
 *  The data to attach.  This will be loaded from the `fileURL`
 */
@property (nonatomic, strong) NSData *fileData;

@end

#endif

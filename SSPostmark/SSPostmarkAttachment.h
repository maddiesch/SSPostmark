//
//  SSPostmarkAttachment.h
//  SSPostmark
//
//  Created by Skylar Schipper on 6/2/13.
//  Copyright (c) 2013 Skylar Schipper. All rights reserved.
//

extern NSString * const SSPostmarkAttachmentInvalidNameException;

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>
#endif

/** A Postmark Email Attachment Object
 
 Postmark will handle sending attachments with emails as long as the raw data doesn't exceede 10MB per message total.
 
 */
@interface SSPostmarkAttachment : NSObject

/** The name for the attached file
 
 The name should have a valid Postmark file extention. Can be found in +[SSPostmarkAttachment allowedAttachmentExtentions]
 
 @warning Will raise `SSPostmarkAttachmentInvalidNameException` if the name is not allowed.
 
 If this is from user input be sure to check the name with +[SSPostmarkAttachment nameIsAllowed:] before setting.
 */
@property (nonatomic, strong) NSString *name;

/** The data for the file attachment.
 
 The data should be base64 encoded.
 */
@property (nonatomic, strong) NSString *content;

/** The MIME content type for the attachment file
 
 If the content type is not provided it will default to `application/octet-stream`
 */
@property (nonatomic, strong) NSString *contentType;

/** Set the content from a NSData object
 
 Will use +[SSPostmarkAttachment base64EndcodeData:] to base64 encode the data
 
 @param data The data to be base64 encoded and set as content
 */
- (void)setContentData:(NSData *)data;

/** The file extentions allowed by Postmark
 
 @return An NSArray containing the list of file extentions
 */
+ (NSArray *)allowedAttachmentExtentions;

/** Indicates if the name will be allowed
 
 @param name The file name
 
 @return A boolean indicating if the name sould be allowed or not
 */
+ (BOOL)nameIsAllowed:(NSString *)name;

/** Base64 encode data
 
 @param The data object to encode
 
 @return The base64 encoded string for the data
 */
+ (NSString *)base64EndcodeData:(NSData *)data;

#if TARGET_OS_IPHONE
/** Return an image attachment object
 
 @param image The UIImage to send as an attachment
 
 @param name The name for the attachment.  The file extention will be used for the encoding
 
 @return A valid SSPostmarkAttachment object
 
 @warning Will return nil if the name file extention is not `png` or `jpeg`
 
 Will also return nil if the image incoding fails
 */
+ (instancetype)attachmentWithImage:(UIImage *)image name:(NSString *)name;
#endif

#pragma mark -
#pragma mark - API Helper Methods
- (NSDictionary *)asJSONObject;
- (NSData *)binaryJSON;


@end

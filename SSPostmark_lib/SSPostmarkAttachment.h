/***
 *    SSPostmark
 *    @author - Skylar Schipper
 *	   @copyright - (2011 - 2012) (c) Skylar Schipper
 *			(All rights reserved)
 *
 *    SSPostmarkAttachment.h
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
#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    #import <UIKit/UIKit.h>
#endif

#import "SSPostmark_Helper.h"


/**
 SSPostmarkAttachment takes an properly formats data to add as an attachment to an SSPostmarkMessage
 
 See [http://developer.postmarkapp.com/developer-build.html#attachments](http://developer.postmarkapp.com/developer-build.html#attachments) for more info on attachments.
 
 */
@interface SSPostmarkAttachment : NSObject

/** The name of the file being added.
 
 This should include a file extension.
 */
@property (nonatomic, strong) NSString *name;

/** Base64 encoded data.
 
 If you use teh addData: method SSPostmarkAttachment will properly encode the data for you.
 */
@property (nonatomic, strong) NSString *content;

/** The MIME type for the data.
 
 If you don't explicitly set this it will default to `application/octet-stream`.
 */
@property (nonatomic, strong) NSString *contentType;

/** Add NSData object for the attachment
 
 This will automaticaly be converted into a base64 string.
 
 @param data The data for the attachment.
 */
- (void)addData:(NSData *)data;

/** Get the attachment as an `NSDictionary`
 
 @return A dictionary representation for the attachment.
 */
- (NSDictionary *)dictionaryRepresentation;

/** Convenience method
 
 Quick way to get a SSPostmarkAttachment instance
 
 @param content NSData of the attachment data
 
 @param contentType NSString or nil.
 
 @param name The name of the image.
 
 @return An initiated SSPostmarkAttachment object
 
 */
+ (SSPostmarkAttachment *)attachmentWithData:(NSData *)content contentType:(NSString *)contentType name:(NSString *)name;


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR // This keeps support for Mac OS X

/** Convenience method
 
 Quick way to get a SSPostmarkAttachment instance
 
 @param image UIImage to add to the attachment
 
 @param name The name of the image.
 
 @return An initiated SSPostmarkAttachment object
 
 */
+ (SSPostmarkAttachment *)attachmentWithImage:(UIImage *)image name:(NSString *)name;

/** Add UIImage
 
 A convenience method for adding a `UIImage`
 
 @param image The UIImage to add to the attachment
 */
- (void)addImage:(UIImage *)image;
#elif TARGET_OS_MAC

/** Convenience method
 
 Quick way to get a SSPostmarkAttachment instance
 
 @param image NSImage to add to the attachment
 
 @param name The name of the image.
 
 @return An initiated SSPostmarkAttachment object
 
 */
+ (SSPostmarkAttachment *)attachmentWithImage:(NSImage *)image name:(NSString *)name;

/** Add NSImage
 
 A convenience method for adding a `NSImage`
 
 @param image The NSImage to add to the attachment
 */
- (void)addImage:(NSImage *)image;
#endif
@end


#pragma mark - Begin Helper Classes
/**
 *  Base64 encoding
 *
 */
static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

@interface NSData (SSBase64)

- (NSString *)ss_base64String;

@end

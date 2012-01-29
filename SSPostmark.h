//
//  SSPostmark.h
//  SSPostmark
//
//  Created by Skylar Schipper on 1/27/12.
//  Copyright (c) 2012 Schipper Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef __IPHONE_5_0
    #warning "This project uses NSJSONSerialization.  Only available in iOS >= 5.0"
#endif

/**
 *
 *  Set your API key
 *
 */
#define pm_YOUR_API_KEY @"POSTMARK_API_TEST"
/**
 *
 *  Set async queue name
 *
 */
#define pm_ASYNC_QUEUE_NAME @"com.sspostmark.queue"

/**
 *
 *  Keys for the NSDictionary Items
 *
 *
 */
static const NSString* kSSPostmarkHTMLBody = @"HtmlBody"; // Expects NSString
static const NSString* kSSPostmarkTextBody = @"TextBody"; // Expects NSString
static const NSString* kSSPostmarkFrom = @"From"; // Expects NSString
static const NSString* kSSPostmarkTo = @"To"; // Expects NSString
static const NSString* kSSPostmarkCC = @"Cc"; // Expects NSString :: OPTIONAL
static const NSString* kSSPostmarkBCC = @"Bcc"; // Expects NSString :: OPTIONAL
static const NSString* kSSPostmarkSubject = @"Subject"; // Expects NSString
static const NSString* kSSPostmarkTag = @"Tag"; // Expects NSString
static const NSString* kSSPostmarkReplyTo = @"ReplyTo"; // Expects NSString
static const NSString* kSSPostmarkHeaders = @"Headers";// Expects NSDictionary :: OPTIONAL

// Forward Declaration of delegate
@protocol SSPostmarkDelegate;

@interface SSPostmark : NSObject
@property (nonatomic, assign) id <SSPostmarkDelegate> delegate;


-(void)sendEmailWithParamaters:(NSDictionary*)params asynchronously:(BOOL)async;


@end

typedef enum {
    SSPMError_Unknown,
    SSPMError_BadMessageDict,
}SSPMErrorType;

@protocol SSPostmarkDelegate <NSObject>

// Option Delegate Methods
@optional
-(void)postmark:(id)postmark returnedMessage:(NSDictionary*)message withStatusCode:(NSUInteger)code;
-(void)postmark:(id)postmark encounteredError:(SSPMErrorType)type;
@end

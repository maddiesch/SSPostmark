//
//  SSPostmark.h
//  SSPostmark
//
//  Created by Skylar Schipper on 7/16/14.
//  Copyright (c) 2014 OpenSky, LLC. All rights reserved.
//

#ifndef SSPostmark_SSPostmark_h
#define SSPostmark_SSPostmark_h

#import "SSPostmarkMessage.h"
#import "SSPostmarkResponse.h"

/**
 *  The Postmark API helper methods
 */
@interface SSPostmark : NSObject

/**
 *  The API key that will be used to authenticate the request to the server
 */
@property (nonatomic, strong, readonly) NSString *apiKey;

/**
 *  Create a new SSPostmark instance with the passed API key
 *
 *  @param apiKey The API key.
 *
 *  @return A new instance
 */
- (instancetype)initWithAPIKey:(NSString *)apiKey;

/**
 *  Send a message to the API for delivery/
 *
 *  The completion block will be called on an arbitrary queue.
 *
 *  @param message    The message instance to send
 *  @param completion The completion block to call when the request is completed/
 */
- (void)sendMessage:(SSPostmarkMessage *)message completion:(void(^)(SSPostmarkResponse *, NSError *))completion;

- (void)sendBatchMessages:(NSArray *)messages completion:(void(^)(NSArray *, NSError *))completion;

@end

FOUNDATION_EXTERN NSString *const SSPostmarkErrorDomain;
typedef NS_ENUM(NSInteger, SSPostmarkErrorCode) {
    SSPostmarkErrorCodeUnknown            = -1,
    SSPostmarkErrorCodeInvalidMessage     = 1,
    SSPostmarkErrorCodeJSONError          = 2,
    SSPostmarkErrorCodePostmarkHTTP       = 3,
    SSPostmarkErrorCodeCocoa              = 4,
    SSPostmarkErrorCodeJSONResponseError  = 5,
    SSPostmarkErrorCodeBatchCountExceeded = 6
};

#endif

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

@interface SSPostmark : NSObject

@property (nonatomic, strong, readonly) NSString *apiKey;

- (instancetype)initWithAPIKey:(NSString *)apiKey;

- (void)sendMessage:(SSPostmarkMessage *)message completion:(void(^)(SSPostmarkResponse *, NSError *))completion;

@end

FOUNDATION_EXTERN NSString *const SSPostmarkErrorDomain;
typedef NS_ENUM(NSInteger, SSPostmarkErrorCode) {
    SSPostmarkErrorCodeUnknown           = -1,
    SSPostmarkErrorCodeInvalidMessage    = 1,
    SSPostmarkErrorCodeJSONError         = 2,
    SSPostmarkErrorCodePostmarkHTTP      = 3,
    SSPostmarkErrorCodeCocoa             = 4,
    SSPostmarkErrorCodeJSONResponseError = 5
};

#endif

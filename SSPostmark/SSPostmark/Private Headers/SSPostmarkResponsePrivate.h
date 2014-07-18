//
//  SSPostmarkResponsePrivate.h
//  SSPostmark
//
//  Created by Skylar Schipper on 7/16/14.
//  Copyright (c) 2014 OpenSky, LLC. All rights reserved.
//

#ifndef SSPostmark_SSPostmarkResponsePrivate_h
#define SSPostmark_SSPostmarkResponsePrivate_h

#import "SSPostmarkResponse.h"

@interface SSPostmarkResponse (PrivateMethods)

- (instancetype)initWithData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError *)error;

+ (NSArray *)responsesWithData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError *)error;

@end

#endif

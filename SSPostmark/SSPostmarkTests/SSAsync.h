/*!
 * SSAsync.h
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/16/14
 */

#ifndef SSAsync_h
#define SSAsync_h

#import <Foundation/Foundation.h>

@interface SSAsync : NSObject

+ (instancetype)async;

- (BOOL)wait;

- (void)complete;

@end

#endif

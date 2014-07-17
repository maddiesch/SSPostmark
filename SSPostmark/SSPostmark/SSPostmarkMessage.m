/*!
 * SSPostmarkMessage.m
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/16/14
 */

#import "SSPostmarkMessage.h"

@interface SSPostmarkMessage ()

@end

@implementation SSPostmarkMessage

- (BOOL)isValid {
    if (self.fromAddress.length == 0) {
        return NO;
    }
    if (!self.subject) {
        return NO;
    }
    if (!self.textBody && !self.HTMLBody) {
        return NO;
    }
    if (self.toAddresses.count == 0) {
        return NO;
    }
    return YES;
}

@end

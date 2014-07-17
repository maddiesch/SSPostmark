/*!
 * SSAsync.m
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/16/14
 */

#import "SSAsync.h"

@interface SSAsync ()

@property (nonatomic, getter = isWaiting) BOOL waiting;

@end

@implementation SSAsync

+ (instancetype)async {
    return [[self alloc] init];
}

- (BOOL)wait {
    NSDate *start = [NSDate date];
    self.waiting = YES;
    
    while (self.waiting) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
        if ([[NSDate date] timeIntervalSinceDate:start] > 10.0) {
            self.waiting = NO;
            return NO;
        }
    }
    
    return YES;
}

- (void)complete {
    self.waiting = NO;
}

@end

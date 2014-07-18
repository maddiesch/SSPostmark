/*!
 * SSPostmarkHeaderItem.m
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/17/14
 */

#import "SSPostmarkHeaderItemPrivate.h"

@interface SSPostmarkHeaderItem ()

@end

@implementation SSPostmarkHeaderItem

- (NSDictionary *)JSONRepresentation {
    return @{
             @"Name": self.name,
             @"Value": self.value
             };
}

@end

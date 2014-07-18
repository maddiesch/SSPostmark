/*!
 * SSPostmarkHeaderItem.h
 *
 * Copyright (c) 2014 OpenSky, LLC
 *
 * Created by Skylar Schipper on 7/17/14
 */

#ifndef SSPostmarkHeaderItem_h
#define SSPostmarkHeaderItem_h

@import Foundation;

@interface SSPostmarkHeaderItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) id value; // Must be a valid JSON object

@end

#endif

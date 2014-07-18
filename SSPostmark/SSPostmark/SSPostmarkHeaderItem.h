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

/**
 *  Postmark can send custom headers with email.
 *
 *  This class can be used to add those to outgoing messages
 */
@interface SSPostmarkHeaderItem : NSObject <NSCopying>

/**
 *  Create a new header object
 *
 *  @param name  The name of the header.
 *  @param value The value for the header.  This must be a vaild JSON object
 *
 *  @return The a new header object
 */
+ (instancetype)headerWithName:(NSString *)name value:(id)value;

/**
 *  The header name
 */
@property (nonatomic, strong) NSString *name;
/**
 *  The header value
 */
@property (nonatomic, strong) id value; // Must be a valid JSON object

@end

#endif

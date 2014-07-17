//
//  SSPostmarkMessagePrivate.h
//  SSPostmark
//
//  Created by Skylar Schipper on 7/16/14.
//  Copyright (c) 2014 OpenSky, LLC. All rights reserved.
//

#ifndef SSPostmark_SSPostmarkMessagePrivate_h
#define SSPostmark_SSPostmarkMessagePrivate_h

#import "SSPostmarkMessage.h"

@interface SSPostmarkMessage (PrivateMethods)

- (NSDictionary *)JSONRepresentation;

+ (NSString *)createEmailStringForSet:(NSSet *)set;

@end

#endif

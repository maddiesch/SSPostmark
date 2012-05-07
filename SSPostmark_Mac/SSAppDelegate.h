//
//  SSAppDelegate.h
//  SSPostmark_Mac
//
//  Created by Skylar Schipper on 5/7/12.
//  Copyright (c) 2012 Schipper Studios. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SSPostmark.h"

@interface SSAppDelegate : NSObject <NSApplicationDelegate, SSPostmarkDelegate>

@property (assign) IBOutlet NSWindow *window;

@end

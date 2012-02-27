//
//  SSAppDelegate.h
//  SSPostmark
//
//  Created by Skylar Schipper on 1/27/12.
//  Copyright (c) 2012 Schipper Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPostmark.h"

@class SSViewController;

@interface SSAppDelegate : UIResponder <UIApplicationDelegate, SSPostmarkDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SSViewController *viewController;


- (void)testNotifications:(NSNotification *)notification;

@end

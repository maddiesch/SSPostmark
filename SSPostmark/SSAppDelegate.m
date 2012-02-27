//
//  SSAppDelegate.m
//  SSPostmark
//
//  Created by Skylar Schipper on 1/27/12.
//  Copyright (c) 2012 Schipper Studios. All rights reserved.
//

#import "SSAppDelegate.h"

#import "SSViewController.h"

@implementation SSAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

// Do something with response
- (void)postmark:(id)postmark returnedMessage:(NSDictionary *)message withStatusCode:(NSUInteger)code {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSLog(@"%@",message);
}
// Error Ocuured
- (void)postmark:(id)postmark encounteredError:(SSPMErrorType)type {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}


- (void)testNotifications:(NSNotification *)notification {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSLog(@"Nofification UserInfo: %@",[notification userInfo]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[SSViewController alloc] initWithNibName:@"SSViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    NSMutableDictionary* mail = [NSMutableDictionary new];
    [mail setObject:@"test.email@domain.com" forKey:kSSPostmarkTo];
    [mail setObject:@"Testing The Mailtoobz" forKey:kSSPostmarkSubject];
    [mail setObject:@"Test Email" forKey:kSSPostmarkTextBody];
    [mail setObject:@"ObjectCTest" forKey:kSSPostmarkTag];
    // Sender Info
    [mail setObject:@"test.email.sender@domain.com" forKey:kSSPostmarkFrom];
    [mail setObject:@"test.email.sender@domain.com" forKey:kSSPostmarkReplyTo];
    
    // Send
    SSPostmark* p = [[SSPostmark alloc]init];
    p.delegate = self;
    [p sendEmailWithParamaters:mail asynchronously:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testNotifications:) name:pm_POSTMARK_NOTIFICATION object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end

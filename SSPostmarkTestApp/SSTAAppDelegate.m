//
//  SSTAAppDelegate.m
//  SSPostmarkTestApp
//
//  Created by Skylar Schipper on 12/14/12.
//  Copyright (c) 2012 Skylar Schipper. All rights reserved.
//

#import "SSTAAppDelegate.h"
#import "SSPostmark.h"
#import "SSPostmarkAttachment.h"

@implementation SSTAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    NSLog(@"SSPostmark Version: '%@'",[SSPostmark version]);
    
    SSPostmarkMessage *message = [SSPostmarkMessage new];
    message.fromEmail = @"ss@schipp.co";
    message.replyTo = @"ss@schipp.co";
    message.to = @"ss@schipp.co";
    message.textBody = @"Test Email";
    message.subject = @"Just a test";
    message.tag = @"sspm-test";
    
    SSPostmarkAttachment *att = [[SSPostmarkAttachment alloc] init];
    att.content = UIImagePNGRepresentation([UIImage imageNamed:@"sunset.jpg"]);
    att.name = @"image.png";
    
    [message addAttachmentsObject:att];
    
    
    [[SSPostmark postmaster] setApiKey:@"b73973a3-1b2f-4134-b30e-d0c635b0c0be"];
    [[SSPostmark postmaster] sendMessage:message];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

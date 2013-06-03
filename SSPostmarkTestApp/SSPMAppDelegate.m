//
//  SSPMAppDelegate.m
//  SSPostmarkTestApp
//
//  Created by Skylar Schipper on 6/2/13.
//  Copyright (c) 2013 Skylar Schipper. All rights reserved.
//

#import "SSPMAppDelegate.h"

#import "SSPMViewController.h"

#import "SSPostmark.h"
#import "SSPostmarkEmail.h"

@implementation SSPMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    SSPostmark *pm = [[SSPostmark alloc] initWithApiKey:@"POSTMARK_API_TEST"];
    
    SSPostmarkEmail *email = [[SSPostmarkEmail alloc] init];
    email.fromAddress = @"valid-sender-email@example.com";
    email.nameForFromAddress = @"Test User";
    email.subject = @"Just Testing SSPostmark";
    [email.toAddresses addObject:@"test@example.com"];
    [email setBody:@"Just Testing" isHTML:NO];
    
    [pm sendEmail:email completion:^(BOOL success, NSError *error) {
        NSLog(@"Success: %i",success);
        NSLog(@"Error: %@",error);
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[SSPMViewController alloc] initWithNibName:@"SSPMViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end

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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    SSPostmarkMessage *message = [SSPostmarkMessage new];
    message.fromEmail = @"ss@schipp.co";
    message.replyTo = @"ss@schipp.co";
    message.to = @"ss@schipp.co";
    message.textBody = @"Test Email";
    message.subject = @"Just a test";
    message.tag = @"sspm-test";
    [message addCompletionBlock:^(SSPostmarkMessage *message, NSUInteger statusCode, NSDictionary *responseJSON) {
        NSLog(@"(%i)\n%@",statusCode,responseJSON);
    }];
    
    [message addAttachmentsObject:[SSPostmarkAttachment attachmentWithImage:[UIImage imageNamed:@"sunset.jpg"] name:@"image.png" type:SSPMImageTypePNG]];
    
    [[SSPostmark postmaster] setApiKey:SSPOSTMARK_TEST_API_KEY];
    [[SSPostmark postmaster] sendMessage:message];
    
    return YES;
}

@end

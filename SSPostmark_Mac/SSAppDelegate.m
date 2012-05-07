//
//  SSAppDelegate.m
//  SSPostmark_Mac
//
//  Created by Skylar Schipper on 5/7/12.
//  Copyright (c) 2012 Schipper Studios. All rights reserved.
//

#import "SSAppDelegate.h"

@implementation SSAppDelegate

- (void)postmark:(id)postmark returnedMessage:(NSDictionary *)message withStatusCode:(NSUInteger)code {
    NSLog(@"Postmark[%@]: %@",[NSNumber numberWithInteger:code], message);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    SSPostmarkMessage *mail = [SSPostmarkMessage new];
    mail.to = @"test.email@domain.com";
    mail.subject = @"Testing The Mailtoobz";
    mail.textBody = @"Test Email";
    mail.tag = @"ObjectCTest";
    // Sender Info
    mail.fromEmail = @"test.email.sender@domain.com";
    mail.replyTo = @"test.email.sender@domain.com";
    
    NSMutableArray *arr = [NSMutableArray new];
    [arr addObject:mail];
    
    mail = nil;
    mail = [SSPostmarkMessage new];
    mail.to = @"test.email.two@domain.com";
    mail.subject = @"Testing The Mailtoobz";
    mail.textBody = @"Test Email";
    mail.tag = @"ObjectCTest";
    // Sender Info
    mail.fromEmail = @"test.email.sender@domain.com";
    mail.replyTo = @"test.email.sender@domain.com";
    
    [arr addObject:mail];
    
    
    // Send
    SSPostmark* p = [[SSPostmark alloc] init];
    p.delegate = self;
    [p sendEmail:mail];
}

@end

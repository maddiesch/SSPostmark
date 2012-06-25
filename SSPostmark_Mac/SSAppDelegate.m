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
    mail.textBody = @"Test Email - Mac";
    mail.tag = @"ObjectCTest - Mac";
    // Sender Info
    mail.fromEmail = @"test.email.sender@domain.com";
    mail.replyTo = @"test.email.sender@domain.com";
    mail.apiKey = @"POSTMARK_API_TEST";
    
    // If you're using the NSImage helper method we'll automaticaly add .png to the end of name if it's not there.
    SSPostmarkAttachment *att = [SSPostmarkAttachment attachmentWithImage:[NSImage imageNamed:@"Downtown_LA.png"] named:@"Downtown"];
    // Add an attachemnt to the array.
    [mail addAttachment:att];
    
    // Send
//    SSPostmark* p = [[SSPostmark alloc] init];
//    p.delegate = self;
//    [p sendEmail:mail];
    
    [SSPostmark sendMessage:mail withCompletion:^(NSDictionary *postmarkResponse, SSPMErrorType errorType) {
        NSLog(@"%s:\n%@",__PRETTY_FUNCTION__,postmarkResponse);
    }];
}

@end

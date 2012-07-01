//
//  SSViewController.m
//  SSPostmark
//
//  Created by Skylar Schipper on 1/27/12.
//  Copyright (c) 2012 Schipper Studios. All rights reserved.
//

#import "SSViewController.h"

@implementation SSViewController

- (void)sendMail:(id)sender {
    SSPostmarkViewController *postmark = [[SSPostmarkViewController alloc] init];
    postmark.barTitle = @"SSPostmark";
    postmark.to = @"test@test.com";
    postmark.apiKey = @"POSTMARK_API_TEST";
    postmark.completionHandler = ^(SSPostmarkViewController *viewController, NSDictionary *postmarkResponse, SSPMErrorType errorType) {
        [self dismissModalViewControllerAnimated:YES];
    };
    postmark.modalPresentationStyle = UIModalPresentationFullScreen;
    postmark.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:postmark animated:YES];
}

@end

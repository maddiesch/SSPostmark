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
    SSPostmarkViewController *pm = [[SSPostmarkViewController alloc] init];
    pm.barTitle = @"SSPostmark";
    pm.to = @"test@test.com";
    pm.modalPresentationStyle = UIModalPresentationFullScreen;
    pm.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:pm animated:YES];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

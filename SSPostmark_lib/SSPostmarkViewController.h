#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
//
//  SSPostmarkViewController.h
//  SSPostmark
//
//  Created by Skylar Schipper on 5/14/12.
//  Copyright (c) 2012 Schipper Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPostmark.h"


#define SSPM_FIELD_PADDING 20
@class SSPostmarkViewController;


typedef void (^SSPostmarkViewControllerCompletionHandler)(SSPostmarkViewController *viewController, NSDictionary *postmarkResponse, SSPMErrorType errorType);

@interface SSPostmarkViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate>

@property (nonatomic, copy) SSPostmarkViewControllerCompletionHandler completionHandler;

@property (nonatomic, retain) NSString *barTitle;
@property (nonatomic, retain) NSString *to;
@property (nonatomic, strong) NSString *apiKey;

- (void)sendMail:(id)sender;

- (void)dismissKeys:(id)sender;
- (void)dismissView:(id)sender;

- (void)keyboardNotification:(NSNotification *)notification;

@end
#endif
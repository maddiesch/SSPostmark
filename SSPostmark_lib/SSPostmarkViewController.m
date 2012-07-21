#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
//
//  SSPostmarkViewController.m
//  SSPostmark
//
//  Created by Skylar Schipper on 5/14/12.
//  Copyright (c) 2012 Schipper Studios. All rights reserved.
//

#import "SSPostmarkViewController.h"

@interface SSPostmarkViewController () {
    UITextField *_subjectField;
    UITextField *_replyToField;
    UITextView *_messageBodyView;
    UIToolbar *_toolBar;
    UIBarButtonItem *_sendButton;
    
    UILabel *_barTitleLabel;
}

- (void)okayToSend;

@end

@implementation SSPostmarkViewController

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    NSString *btnTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:@"Send Anyways"]) {
        [self okayToSend];
    }
}

- (void)okayToSend {
    SSPostmarkMessage *message = [SSPostmarkMessage new];
    message.to = self.to;
    message.replyTo = _replyToField.text;
    message.fromEmail = _replyToField.text;
    message.subject = _subjectField.text;
    message.textBody = _messageBodyView.text;
    message.tag = @"SSPostmark View";
    
    [SSPostmark sendMessage:message apiKey:_apiKey completion:^(NSDictionary *postmarkResponse, SSPMErrorType errorType) {
        if (_completionHandler != nil) {
            _completionHandler(self, postmarkResponse, errorType);
        }
    }];
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissView:)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendMail:)];
    _toolBar.items = @[cancel, flex, _sendButton];
    [self.view addSubview:_toolBar];
    
    /**
     *
     *  Reply To Field
     *
     */
    _replyToField = [[UITextField alloc] initWithFrame:CGRectMake(-1,
                                                                 43,
                                                                 self.view.frame.size.width + 2,
                                                                 28)];
    _replyToField.delegate = self;
    _replyToField.borderStyle = UITextBorderStyleLine;
    _replyToField.placeholder = @"Your Email";
    _replyToField.keyboardType = UIKeyboardTypeEmailAddress;
    [_replyToField addTarget:self
                      action:@selector(dismissKeys:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.view addSubview:_replyToField];
    
    /**
     *
     *  Subject Field
     *
     */
    _subjectField = [[UITextField alloc] initWithFrame:CGRectMake(-1,
                                                                  _replyToField.frame.origin.y + _replyToField.frame.size.height - 1,
                                                                  self.view.frame.size.width + 2,
                                                                  28)];
    _subjectField.delegate = self;
    _subjectField.borderStyle = UITextBorderStyleLine;
    _subjectField.placeholder = @"Subject";
    [_subjectField addTarget:self
                      action:@selector(dismissKeys:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.view addSubview:_subjectField];
    
    /**
     *
     *  Message View
     *
     */
    _messageBodyView = [[UITextView alloc] initWithFrame:CGRectMake(0,
                                                                    (_subjectField.frame.origin.y + _subjectField.frame.size.height),
                                                                    self.view.frame.size.width,
                                                                    self.view.frame.size.height - (_subjectField.frame.origin.y + _subjectField.frame.size.height))];
    _messageBodyView.delegate = self;
    _messageBodyView.font = [UIFont systemFontOfSize:15];
    _messageBodyView.backgroundColor = self.view.backgroundColor;
    
    [self.view addSubview:_messageBodyView];
    
    if (_barTitle) {
        self.barTitle = _barTitle;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _sendButton.title = @"Done";
    _sendButton.action = @selector(dismissKeys:);
}
- (void)textViewDidEndEditing:(UITextField *)textField {
    _sendButton.title = @"Send";
    _sendButton.action = @selector(sendMail:);
}


- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)sendMail:(id)sender {
    for (UITextView *v in self.view.subviews) {
        [v resignFirstResponder];
    }
    for (UITextField *f in self.view.subviews) {
        [f resignFirstResponder];
    }
    if ([_replyToField.text isEqualToString:@""] || ![SSPostmark isValidEmail:_replyToField.text]) {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                    message:@"Please enter a vaild email address into the \"Your Email\" field.  This is the email we'll respond to."
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil, nil];
        [a show];
        return;
    }
    BOOL showSheet = NO;
    if ([_subjectField.text isEqualToString:@""]) {
        showSheet = YES;
    }
    if ([_messageBodyView.text isEqualToString:@""]) {
        showSheet = YES;
    }
    if (showSheet) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Missing Fields" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Send Anyways", nil];
        [sheet showInView:self.view];
    } else {
        [self okayToSend];
    }
}

- (void)keyboardNotification:(NSNotification *)notification {
    CGFloat keyDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] - .01;
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        if ([_messageBodyView isFirstResponder]) {
            [UIView animateWithDuration:keyDuration animations:^{
                _messageBodyView.frame = CGRectMake(0, 44, _messageBodyView.frame.size.width, (self.view.frame.size.height - 44) - frame.size.height);
            }];
        }
    }
    
    if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        if ([_messageBodyView isFirstResponder]) {
            [UIView animateWithDuration:keyDuration animations:^{
                _messageBodyView.frame = CGRectMake(0,
                                                    (_subjectField.frame.origin.y + _subjectField.frame.size.height),
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.height - (_subjectField.frame.origin.y + _subjectField.frame.size.height));
            }];
        }
    }
}

- (void)dismissKeys:(id)sender {
    if (sender == _sendButton) {
        [_messageBodyView resignFirstResponder];
        return;
    }
    [sender resignFirstResponder];
}
- (void)dismissView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setBarTitle:(NSString *)barTitle {
    _barTitle = barTitle;
    if (_barTitleLabel == nil) {
        _barTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - 90, 10, 180, 24)];
        _barTitleLabel.font = [UIFont boldSystemFontOfSize:20];
        _barTitleLabel.shadowColor = [UIColor grayColor];
        _barTitleLabel.shadowOffset = CGSizeMake(0, -1);
        _barTitleLabel.backgroundColor = [UIColor clearColor];
        _barTitleLabel.textColor = [UIColor whiteColor];
        _barTitleLabel.textAlignment = UITextAlignmentCenter;
        [self.view addSubview:_barTitleLabel];
    }
    _barTitleLabel.text = barTitle;
    [self.view bringSubviewToFront:_barTitleLabel];
}

@end
#endif

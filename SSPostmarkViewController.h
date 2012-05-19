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

@interface SSPostmarkViewController : UIViewController <SSPostmarkDelegate, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) NSString *barTitle;
@property (nonatomic, retain) NSString *to;

- (void)sendMail:(id)sender;

- (void)dismissKeys:(id)sender;
- (void)dismissView:(id)sender;

- (void)keyboardNotification:(NSNotification *)notification;

@end

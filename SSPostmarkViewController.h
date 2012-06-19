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

@protocol SSPostmarkViewDelegate;

@interface SSPostmarkViewController : UIViewController <SSPostmarkDelegate, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate>

@property (nonatomic, assign) id<SSPostmarkViewDelegate> delegate;

@property (nonatomic, retain) NSString *barTitle;
@property (nonatomic, retain) NSString *to;
@property (nonatomic, strong) NSString *apiKey;

- (void)sendMail:(id)sender;

- (void)dismissKeys:(id)sender;
- (void)dismissView:(id)sender;

- (void)keyboardNotification:(NSNotification *)notification;

@end


@protocol SSPostmarkViewDelegate <SSPostmarkDelegate>

@required


@end

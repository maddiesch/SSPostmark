//
//  SSPostmarkEmail.h
//  SSPostmark
//
//  Created by Skylar Schipper on 6/2/13.
//  Copyright (c) 2013 Skylar Schipper. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, SSPostmarkEmailValidations) {
    SSPostmarkEmailValidationsNone = 0,
    SSPostmarkEmailValidateEmail   = 1 << 1
};
extern NSString * const SSPostmarkValidationEmailError;

@interface SSPostmarkEmail : NSObject

@property (nonatomic, strong) NSString *address;


#pragma mark -
#pragma mark - Validations
@property (nonatomic) SSPostmarkEmailValidations validations;

- (NSArray *)errors;

- (BOOL)isValid;

@end

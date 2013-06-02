//
//  SSPostmarkEmail.m
//  SSPostmark
//
//  Created by Skylar Schipper on 6/2/13.
//  Copyright (c) 2013 Skylar Schipper. All rights reserved.
//

#import "SSPostmarkEmail.h"
#import "SSPostmarkValidators.h"

@interface SSPostmarkEmail ()

@property (nonatomic, strong) NSMutableArray *errorArray;

@end

@implementation SSPostmarkEmail

- (id)init {
    self = [super init];
    if (self) {
        _validations = SSPostmarkEmailValidateEmail;
    }
    return self;
}

#pragma mark -
#pragma mark - Validations
- (BOOL)isValid {
    [self _performValidations];
    return [self.errorArray count] == 0;
}
- (void)_performValidations {
    [self.errorArray removeAllObjects];
    if (self.validations & SSPostmarkEmailValidateEmail && (!self.address || ![SSPostmarkValidators validatesEmail:self.address type:SSPostmarkEmailAddressValidateStrict])) {
        [self.errorArray addObject:[NSError errorWithDomain:SSPostmarkValidationEmailError code:1 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Email address invalid", @"Localized description for SSPostmark email address validation error")}]];
    }
}

- (NSArray *)errors {
    return [NSArray arrayWithArray:self.errorArray];
}

#pragma mark -
#pragma mark - Lazy Loaders
- (NSMutableArray *)errorArray {
    if (!_errorArray) {
        _errorArray = [NSMutableArray new];
    }
    return _errorArray;
}

@end

NSString * const SSPostmarkValidationEmailError = @"com.skylarsch.emailvalidations";

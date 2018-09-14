//
//  OTSignatureModel+OTSignIn.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/21.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTSignatureModel+OTSignIn.h"


@implementation OTSignatureModel (OTSignIn)

@dynamic userPassword;

- (void)setUserPassword:(NSString *)userPassword {
    if (userPassword) {
        self.paramsDic[kSignatureKeyPassword] = userPassword;
    }
}

@end

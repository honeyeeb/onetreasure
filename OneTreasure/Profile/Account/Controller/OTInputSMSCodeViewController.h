//
//  OTInputSMSCodeViewController.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/24.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTBaseViewController.h"

@class OTSignatureModel;

/// 输入验证码
@interface OTInputSMSCodeViewController : OTBaseViewController

/// 传递页面需要的参数，手机号，验证码，验证码ID
@property (nonatomic, strong) OTSignatureModel *signatureModel;

@end

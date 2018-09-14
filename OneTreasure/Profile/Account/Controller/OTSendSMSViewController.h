//
//  OTSendSMSViewController.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/24.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTBaseViewController.h"

/// 发送验证码，下一场景
typedef NS_ENUM(NSInteger, OTSendSMSDestination) {
    /// 注册
    OTSendSMSDestinationSignUp,
    /// 重置密码(忘记密码)
    OTSendSMSDestinationResetPwd,
    
};

/// 发送手机号码
@interface OTSendSMSViewController : OTBaseViewController

/// 下一场景
@property (nonatomic, assign) OTSendSMSDestination destination;

@end

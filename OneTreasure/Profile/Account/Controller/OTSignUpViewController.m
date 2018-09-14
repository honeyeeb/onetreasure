//
//  OTSignUpViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/20.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTSignUpViewController.h"

#import "JVFloatLabeledTextField.h"
#import "OTAccountManager.h"
#import "OTSignatureModel+OTSignUp.h"
#import "YYTimer.h"
#import "NSString+OTUtils.h"
#import "OTSignatureModel+OTSignUp.h"
#import "OTStatistics.h"


@interface OTSignUpViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *phoneTextFiled;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *smsCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *smsCodeBtn;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (strong, nonatomic) YYTimer *smsTimer;
// 发送短信的短信ID
@property (strong, nonatomic) NSString *smsID;

@property (nonatomic, assign) NSInteger repeatTime;

@end


@implementation OTSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    [self invalidateTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    _submitBtn.layer.cornerRadius = 4.0;
    _submitBtn.layer.masksToBounds = YES;
    
    _smsCodeBtn.layer.cornerRadius = 4.0;
    _smsCodeBtn.layer.masksToBounds = YES;
    
    [self submitBtnEnable:NO];
    
}

- (void)invalidateTimer {
    [_smsTimer invalidate];
    _smsTimer = nil;
}

- (void)setSMSCodeBtnEnable:(BOOL)enable title:(NSString *)title {
    _smsCodeBtn.userInteractionEnabled = enable;
    if (enable) {
        _smsCodeBtn.backgroundColor = RGB_COLOR(241, 96, 84, 1.0);
    } else {
        _smsCodeBtn.backgroundColor = [UIColor lightGrayColor];
    }
    [_smsCodeBtn setTitle:title forState:UIControlStateNormal];
}

- (void)submitBtnEnable:(BOOL)enable {
    _submitBtn.userInteractionEnabled = enable;
    if (enable) {
        _submitBtn.backgroundColor = RGB_COLOR(18, 150, 219, 1.0);
    } else {
        _submitBtn.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)smsTimerAction {
    /// 更新验证码按钮状态
    _repeatTime --;
    BOOL end = (_repeatTime == 0);
    NSString *title;
    if (end) {
        title = @"获取";
        [self invalidateTimer];
    } else {
        title = [NSString stringWithFormat:@"(%d)秒", (int)_repeatTime];
    }
    [self setSMSCodeBtnEnable:end title:title];
}

- (void)setSMSTimerAction {
    if (_smsTimer) {
        [_smsTimer invalidate];
    }
    _repeatTime = 61;
    _smsTimer = [YYTimer timerWithTimeInterval:1.0 target:self selector:@selector(smsTimerAction) repeats:YES];
    [_smsTimer fire];
}

- (IBAction)submitBtnAction:(UIButton *)sender {
    [self sendSignUpRequest];
}

// 获取短信验证码
- (IBAction)smsCodeBtnAction:(UIButton *)sender {
    
    [self sendSMSCodeRequest];
}

- (IBAction)tapGestureAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)statisticsMobile:(NSString *)mobile event:(NSString *)event {
    // 发送短信成功
    if (!mobile) {
        mobile = @"";
    }
    [OTStatistics event:event attributes:@{ @"phone": mobile}];
}

/// 发送短信验证码
- (void)sendSMSCodeRequest {
    if (![[NSString trimEmptyText:_phoneTextFiled.text] isValidTelPhoneNumber]) {
        [self showHUDErrorWithStatus:@"请输入有效的电话号码"];
        return;
    }
    [self setSMSTimerAction];
    
    [_smsCodeTextField becomeFirstResponder];
    
    OTSignatureModel *model = [[OTSignatureModel alloc] init];
    NSString *mobile = [NSString trimEmptyText:_phoneTextFiled.text];
    model.mobile = mobile;
    NSString *params = [model seriaParamString];
    WEAKSELF
    [[OTAccountManager sharedManger] sendSMSParams:params completion:^(NSString *smsID, NSString *errMsg) {
       
        if (smsID) {
            weakSelf.smsID = smsID;
            [weakSelf showHUDInfoWithStatus:@"请查收短信息"];
            
            [weakSelf statisticsMobile:mobile event:@"ot_signup_send_sms_success"];
        } else {
            [weakSelf showHUDErrorWithStatus:errMsg];
            
            [weakSelf statisticsMobile:mobile event:@"ot_signup_send_sms_failed"];
        }
    }];
}

- (void)sendSignUpRequest {
    if (![[NSString trimEmptyText:_phoneTextFiled.text] isValidTelPhoneNumber]) {
        [self showHUDErrorWithStatus:@"请输入常用的电话号码"];
        return;
    }
    if (![_smsCodeTextField.text isValidInvitationCode]) {
        [self showHUDErrorWithStatus:@"请输入短信验证码"];
        return;
    }
    if (![_passwordTextFiled.text isValidPassword]) {
        [self showHUDErrorWithStatus:@"请输入有效的密码"];
    }
    OTSignatureModel *model = [[OTSignatureModel alloc] init];
    NSString *mobile = [NSString trimEmptyText:_phoneTextFiled.text];
    model.mobile = mobile;
    model.userPassword = _passwordTextFiled.text;
    model.smsID = self.smsID;
    model.smsCode = _smsCodeTextField.text;
    NSString *params = [model seriaParamString];
    WEAKSELF
    [[OTAccountManager sharedManger] signUpParams:params completion:^(BOOL success, NSString *errMsg) {
       
        if (success) {
            
            [weakSelf statisticsMobile:mobile event:@"ot_signup_success"];
            // 成功,返回登录界面
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *userInfo = model.paramsDic;
                [[NSNotificationCenter defaultCenter] postNotificationName:kSignUpSuccessNotification object:self userInfo:userInfo];
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [weakSelf statisticsMobile:mobile event:@"ot_signup_failed"];
            [weakSelf showHUDErrorWithStatus:errMsg];
        }
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _phoneTextFiled) {
        if (string.length > 0) {
            if (textField.text.length == 3) {
                textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
            }
            if (textField.text.length == 8) {
                textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
            }
            if (textField.text.length == 13) {
                return NO;
            }
        }
    }
    [self submitBtnEnable:(![@"" isEqualToString:_passwordTextFiled.text] && ![@"" isEqualToString:_phoneTextFiled.text])];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self sendSignUpRequest];
    return YES;
}


@end

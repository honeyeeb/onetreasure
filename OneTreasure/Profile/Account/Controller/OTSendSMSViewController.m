//
//  OTSendSMSViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/24.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTSendSMSViewController.h"
#import "OTResetPasswordViewController.h"

#import "JVFloatLabeledTextField.h"
#import "OTAccountManager.h"
#import "OTSignatureModel+OTSignUp.h"
#import "NSString+OTUtils.h"
#import "YYTimer.h"


/// 重置密码
NSString *const kSendSMSResetPwdSegue                          = @"ot_send_sms_reset_password_segue_id";



@interface OTSendSMSViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *conformBtn;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *smsCodeBtn;

@property (strong, nonatomic) OTSignatureModel *signModel;

@property (strong, nonatomic) YYTimer *smsTimer;

@property (nonatomic, assign) NSInteger repeatTime;

@end

@implementation OTSendSMSViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"手机号码";
    _conformBtn.layer.cornerRadius = 4.0;
    _conformBtn.layer.masksToBounds = YES;
    
    _smsCodeBtn.layer.cornerRadius = 4.0;
    _smsCodeBtn.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self submitBtnEnable:NO];
}

- (void)dealloc {
    
    [self invalidateTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_phoneTextField becomeFirstResponder];
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
    _conformBtn.userInteractionEnabled = enable;
    if (enable) {
        _conformBtn.backgroundColor = RGB_COLOR(18, 150, 219, 1.0);
    } else {
        _conformBtn.backgroundColor = [UIColor lightGrayColor];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([kSendSMSResetPwdSegue isEqualToString:segue.identifier]) {
        // 重置密码
        OTResetPasswordViewController *resetVC = segue.destinationViewController;
        resetVC.signatureModel = self.signModel;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (_phoneTextField.isFirstResponder) {
        [_phoneTextField resignFirstResponder];
    }
}

- (void)varifiedPhone {
    if (![[NSString trimEmptyText:_phoneTextField.text] isValidTelPhoneNumber]) {
        [self showHUDErrorWithStatus:@"请输入有效的手机号"];
        return;
    }
    [self setSMSTimerAction];
    
    [_passwordTextField becomeFirstResponder];
    [self showHUD];
    _signModel = [[OTSignatureModel alloc] init];
    _signModel.mobile = [NSString trimEmptyText:_phoneTextField.text];
    NSString *params = [_signModel seriaParamString];
    WEAKSELF
    [[OTAccountManager sharedManger] sendSMSParams:params completion:^(NSString *smsID, NSString *errMsg) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (smsID) {
                [weakSelf dismissHUD];
                weakSelf.signModel.smsID = smsID;
            } else {
                [weakSelf showHUDErrorWithStatus:errMsg];
                
            }
        });

    }];
}

- (IBAction)confirmBtnAction:(id)sender {
    if (![[NSString trimEmptyText:_phoneTextField.text] isValidTelPhoneNumber]) {
        [self showHUDErrorWithStatus:@"请输入有效的手机号"];
        return;
    }
    if (![[NSString trimEmptyText:_passwordTextField.text] isValidInvitationCode]) {
        [self showHUDErrorWithStatus:@"请输入有效验证码"];
        return;
    }
    [self.view endEditing:YES];
    switch (_destination) {
        case OTSendSMSDestinationSignUp:
            
            break;
            
        case OTSendSMSDestinationResetPwd:
            
            [self performSegueWithIdentifier:kSendSMSResetPwdSegue sender:nil];
            break;
    }
}

- (IBAction)smsCodeBtnAction:(UIButton *)sender {
    [self varifiedPhone];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _phoneTextField) {
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
    
    [self submitBtnEnable:(![@"" isEqualToString:_phoneTextField.text])];
    return YES;
}

@end

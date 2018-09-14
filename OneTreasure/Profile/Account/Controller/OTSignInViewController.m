//
//  OTSignInViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/19.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTSignInViewController.h"

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "JVFloatLabeledTextField.h"
#import "NSString+OTUtils.h"
#import "OTSignatureModel+OTSignIn.h"
#import "OTSendSMSViewController.h"

#import "OTNetworkManager.h"
#import "OTAccountManager.h"
#import "OTCommon.h"
#import "OTStatistics.h"


static NSString *const kSignInSinUpSegueID                                          = @"ot_sign_in_sign_up_segue_id";
NSString *const kSigninSendSMSSegueID                                               = @"ot_signin_send_sms_segue_id";


@interface OTSignInViewController ()

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *phoneTextField;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIButton *forgetPwsBtn;


@end

@implementation OTSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signUpSuccess:) name:kSignUpSuccessNotification object:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(signInLeftBtnAction:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(signInRightBtnAction:)];
    
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSignUpSuccessNotification object:nil];
}

- (void)setupViews {
    _confirmBtn.layer.cornerRadius = 4.0;
    _confirmBtn.layer.masksToBounds = YES;
    
    [_phoneTextField becomeFirstResponder];
    
    [self submitBtnEnable:NO];
}

- (void)signUpSuccess:(NSNotification *)notifi {
    NSDictionary *userInfo = notifi.userInfo;
    if (userInfo.count > 0) {
        NSString *phone = userInfo[kSignatureKeyMobile];
        NSString *password = userInfo[kSignatureKeyPassword];
        
        _phoneTextField.text = phone;
        _passTextField.secureTextEntry = NO;
        _passTextField.text = password;
    }
}

- (void)submitBtnEnable:(BOOL)enable {
    _confirmBtn.userInteractionEnabled = enable;
    if (enable) {
        _confirmBtn.backgroundColor = RGB_COLOR(18, 150, 219, 1.0);
    } else {
        _confirmBtn.backgroundColor = [UIColor lightGrayColor];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([kSigninSendSMSSegueID isEqualToString:segue.identifier]) {
        OTSendSMSViewController *sendSMSVC = segue.destinationViewController;
        sendSMSVC.destination = OTSendSMSDestinationResetPwd;
    }
}

/// 返回
- (void)signInLeftBtnAction:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/// 注册
- (void)signInRightBtnAction:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:kSignInSinUpSegueID sender:nil];
}

- (IBAction)confirmBtnAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [self validatedInputs];
}

- (IBAction)tapGestureAction:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
}

- (IBAction)forgetPwdBtnAction:(UIButton *)sender {
    
    [self performSegueWithIdentifier:kSigninSendSMSSegueID sender:nil];
}

#pragma mark - Network
- (void)sendSignInRequest {
    
    [self showHUD];
    OTSignatureModel *signModel = [[OTSignatureModel alloc] init];
    signModel.mobile = [NSString trimEmptyText:_phoneTextField.text];
    signModel.userPassword = _passTextField.text;
    NSString *params = signModel.seriaParamString;
    WEAKSELF
    [[OTAccountManager sharedManger] signinWithParams:params completion:^(BOOL success, NSString *errMsg) {
        if (success) {
            [weakSelf dismissHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            });
            
            // 登录成功统计
            [OTStatistics profileSignInWithPUID:[OTAccountManager sharedManger].userID];
            [OTStatistics setAlias:[OTAccountManager sharedManger].userID type:@"mobile" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.phoneTextField becomeFirstResponder];
            });
            [weakSelf showHUDErrorWithStatus:errMsg];
        }
    }];
    
}

- (void)validatedInputs {
    if (![[NSString trimEmptyText:_phoneTextField.text] isValidTelPhoneNumber]) {
        [self showHUDErrorWithStatus:@"请输入常用的电话号码"];
        return;
    }
    if (![_passTextField.text isValidPassword]) {
        [self showHUDErrorWithStatus:@"请输入有效的密码"];
        return;
    }
    [self sendSignInRequest];
}

#pragma mark - UITextFieldDelegate

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
    } else if (textField == _passTextField) {
        textField.secureTextEntry = YES;
    }
    
    [self submitBtnEnable:(![@"" isEqualToString:_phoneTextField.text])];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self validatedInputs];
    return YES;
}

@end

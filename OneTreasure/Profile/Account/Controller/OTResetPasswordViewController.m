//
//  OTResetPasswordViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/25.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTResetPasswordViewController.h"

#import "OTAccountManager.h"
#import "OTSignatureModel+OTSignUp.h"
#import "JVFloatLabeledTextField.h"
#import "NSString+OTUtils.h"
#import "OTUserModel.h"


@interface OTResetPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *pwdTextField;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *confirmPwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;



@end

@implementation OTResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
    
}

- (void)viewWillDisAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    self.title = @"重置密码";
    
    _confirmBtn.layer.cornerRadius = 4.0;
    _confirmBtn.layer.masksToBounds = YES;
    
    [self setEditing:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

- (void)submitBtnEnable:(BOOL)enable {
    _confirmBtn.userInteractionEnabled = enable;
    if (enable) {
        _confirmBtn.backgroundColor = RGB_COLOR(18, 150, 219, 1.0);
    } else {
        _confirmBtn.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)validatedInputs {
    
    if (![_pwdTextField.text isValidPassword] || ![_confirmPwdTextField.text isValidPassword]) {
        [self showHUDErrorWithStatus:@"请输入正确的密码(6~20位)"];
        return;
    }
    if (![_pwdTextField.text isEqualToString:_confirmPwdTextField.text]) {
        [self showHUDErrorWithStatus:@"两次密码输入不一致"];
        return;
    }
    
    [self.view endEditing:YES];
    
    [self resetPasswordRequest];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)confirmBtnAction:(UIButton *)sender {
    [self validatedInputs];
}

#pragma mark - Network

- (void)resetPasswordRequest {
    [_signatureModel setHelloWorld:[OTAccountManager sharedManger].userModel.accessToken];
    NSString *params = [_signatureModel seriaParamString];
    [self showHUD];
    WEAKSELF
    [[OTAccountManager sharedManger] resetPwdWithParams:params completion:^(BOOL success, NSString *errMsg) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [weakSelf dismissHUD];
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            } else {
                
                [weakSelf showHUDErrorWithStatus:errMsg];
            }
        });
        
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    [self submitBtnEnable:([_pwdTextField.text isValidPassword])];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _pwdTextField) {
        [_confirmPwdTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self validatedInputs];
    }
    return YES;
}


@end

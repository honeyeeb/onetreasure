//
//  OTModifyPasswordViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/24.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTModifyPasswordViewController.h"
#import "JVFloatLabeledTextField.h"

#import "OTAccountManager.h"
#import "OTSignatureModel+OTModifyPassword.h"
#import "NSString+OTUtils.h"
#import "OTUserModel.h"



@interface OTModifyPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *pwdTextField;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *confirmPwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;



@end

@implementation OTModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(modifyPwdLeftBtnAction:animatd:)];
    
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

- (void)setupViews {
    
    self.title = @"修改密码";
    
    _confirmBtn.layer.cornerRadius = 4.0;
    _confirmBtn.layer.masksToBounds = YES;
    
    [self setEditing:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

/// 返回
- (void)modifyPwdLeftBtnAction:(UIBarButtonItem *)sender animatd:(BOOL)animated {
    if (sender) {
        animated = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.ModifiedPassword) {
        // 修改密码，重新登录
        self.ModifiedPassword(!animated);
    }
    self.ModifiedPassword = nil;
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
    
}

- (IBAction)confirmBtnAction:(UIButton *)sender {
    
    [self varifiedInputs];
}

- (void)varifiedInputs {
    if (![_pwdTextField.text isValidPassword] || ![_confirmPwdTextField.text isValidPassword]) {
        [self showHUDInfoWithStatus:@"请填写有效密码"];
        return;
    }
    
    [self.view endEditing:YES];
    OTSignatureModel *signatureModel = [[OTSignatureModel alloc] init];
    signatureModel.originPassword = _pwdTextField.text;
    signatureModel.newPassword = _confirmPwdTextField.text;
    [signatureModel setHelloWorld:[OTAccountManager sharedManger].userModel.accessToken];
    signatureModel.userID = [OTAccountManager sharedManger].userID;
    NSString *params = [signatureModel seriaParamString];
    WEAKSELF
    [self showHUD];
    [[OTAccountManager sharedManger] modifyPwdWithParams:params completion:^(BOOL success, NSString *errMsg) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [weakSelf dismissHUD];
                [weakSelf modifyPwdLeftBtnAction:nil animatd:NO];
                
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
        [self varifiedInputs];
    }
    return YES;
}


@end

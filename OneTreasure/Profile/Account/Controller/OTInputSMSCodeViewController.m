//
//  OTInputSMSCodeViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/24.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTInputSMSCodeViewController.h"

#import "OTSignatureModel.h"


NSString *const kMsgPreFormat                               = @"短息验证码已发送至 ";

NSString *const kMsgEndFormat                               = @" 请填写验证码";




@interface OTInputSMSCodeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;
@property (weak, nonatomic) IBOutlet UITextField *textField5;
@property (weak, nonatomic) IBOutlet UITextField *textField6;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;



@end

@implementation OTInputSMSCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    
    self.title = @"验证码";
    [self setViewsBorders:_textField1];
    [self setViewsBorders:_textField2];
    [self setViewsBorders:_textField3];
    [self setViewsBorders:_textField4];
    [self setViewsBorders:_textField5];
    [self setViewsBorders:_textField6];
    
    NSString *msg = [kMsgPreFormat stringByAppendingFormat:@"%@%@", _signatureModel.mobile, kMsgEndFormat];
    _msgLabel.text = msg;
}

- (void)setViewsBorders:(UIView *)view {
    if (view) {
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        view.layer.cornerRadius = 4.0;
        view.layer.masksToBounds = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _textField1) {
        if (toBeString.length > 0) {
            [_textField2 becomeFirstResponder];
        } else {
            
        }
    } else if(textField == _textField2) {
        if (toBeString.length > 0) {
            [_textField3 becomeFirstResponder];
        } else {
            [_textField1 becomeFirstResponder];
        }
    } else if(textField == _textField3) {
        if (toBeString.length > 0) {
            [_textField4 becomeFirstResponder];
        } else {
            [_textField2 becomeFirstResponder];
        }
    } else if(textField == _textField4) {
        if (toBeString.length > 0) {
            [_textField5 becomeFirstResponder];
        } else {
            [_textField3 becomeFirstResponder];
        }
    } else if(textField == _textField5) {
        if (toBeString.length > 0) {
            [_textField6 becomeFirstResponder];
        } else {
            [_textField4 becomeFirstResponder];
        }
    } else if(textField == _textField6) {
        if (toBeString.length > 0) {
            // 提交
            
        } else {
            [_textField5 becomeFirstResponder];
        }
    }
    
    return YES;
}


@end

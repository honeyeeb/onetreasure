//
//  OTChargeViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/29.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTChargeViewController.h"

#import "NSString+OTUtils.h"
#import "JVFloatLabeledTextField.h"
#import "OTCommon.h"
#import "OTSignatureModel+OTRecharge.h"
#import "OTAccountManager.h"
#import "OTUserModel.h"
#import "OTPayManager.h"
#import "OTStatistics.h"



#define kDefaultBGColor                     RGB_COLOR(210, 210, 210, 1.0)
#define kSelectBGColor                      [UIColor colorWithRed:0.94 green:0.46 blue:0.29 alpha:1.00]

#define kSubmitBtnColor                     RGB_COLOR(18, 150, 219, 1.0)



typedef NS_ENUM(NSInteger, OTChargeType) {
    OTChargeTypeNone            = 0,
    OTChargeType1               = 10,
    OTChargeType2               = 50,
    OTChargeType3               = 100,
    OTChargeType4               = 200,
    OTChargeTypeText,
};

@interface OTChargeViewController ()<UITextFieldDelegate>
/// 价格输入
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textField;
/// 10元
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn1;
/// 50
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn2;
/// 100
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn3;
/// 200
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn4;
/// 支付宝支付方式
@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;
/// 微信支付方式
@property (weak, nonatomic) IBOutlet UIButton *wechatPayBtn;
/// 重置按钮
@property (weak, nonatomic) IBOutlet UIButton *submitPayBtn;
/// 支付方式
@property (assign, nonatomic) OTPayType payType;
/// 支付金额
@property (assign, nonatomic) OTChargeType chargeType;

@end

@implementation OTChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"余额充值";
    _payType = OTPayTypeWeChat;
    
    [self setupDefaultView];
    
    _wechatPayBtn.hidden = ![self canOpenWeChat];
    _aliPayBtn.hidden = ![self canOpenAliPay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [_textField resignFirstResponder];
}

- (void)setupDefaultView {
    
    [self setSubmitBtnSelected:NO];
    [self setChargeBtnDefault];
    
    [self setPayButton];
}

- (BOOL)canOpenWeChat {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
}

- (BOOL)canOpenAliPay {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]];
}

- (void)setPayButton {
    if (_payType == OTPayTypeAliPay) {
        [_wechatPayBtn setImage:[UIImage imageNamed:@"ot_pay_wechat_0"] forState:UIControlStateNormal];
        [_aliPayBtn setImage:[UIImage imageNamed:@"ot_pay_shifubao_1"] forState:UIControlStateNormal];
    } else {
        [_wechatPayBtn setImage:[UIImage imageNamed:@"ot_pay_wechat_1"] forState:UIControlStateNormal];
        [_aliPayBtn setImage:[UIImage imageNamed:@"ot_pay_shifubao_0"] forState:UIControlStateNormal];

    }
}

- (void)setBtnColor:(UIButton *)btn selected:(BOOL)selected {
    if (selected) {
        [btn setBackgroundColor:kSelectBGColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [btn setBackgroundColor:kDefaultBGColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }
}

- (void)setChargeBtnDefault {
    [self setBtnColor:_chargeBtn1 selected:NO];
    [self setBtnColor:_chargeBtn2 selected:NO];
    [self setBtnColor:_chargeBtn3 selected:NO];
    [self setBtnColor:_chargeBtn4 selected:NO];
}

- (void)setSubmitBtnSelected:(BOOL)selected {
    if (selected) {
        [_submitPayBtn setBackgroundColor:kSubmitBtnColor];
        [_submitPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [_submitPayBtn setBackgroundColor:kDefaultBGColor];
        [_submitPayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }
    [_submitPayBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
}

- (IBAction)chargeBtn1Action:(UIButton *)sender {
    [self setChargeBtnDefault];
    [self setBtnColor:_chargeBtn1 selected:YES];
    _chargeType = OTChargeType1;
    [self setSubmitBtnSelected:YES];
}

- (IBAction)chargeBtn2Action:(id)sender {
    [self setChargeBtnDefault];
    [self setBtnColor:_chargeBtn2 selected:YES];
    _chargeType = OTChargeType2;
    [self setSubmitBtnSelected:YES];
}

- (IBAction)chargeBtn3Action:(id)sender {
    [self setChargeBtnDefault];
    [self setBtnColor:_chargeBtn3 selected:YES];
    _chargeType = OTChargeType3;
    [self setSubmitBtnSelected:YES];
}

- (IBAction)chargeBtn4Action:(id)sender {
    [self setChargeBtnDefault];
    [self setBtnColor:_chargeBtn4 selected:YES];
    _chargeType = OTChargeType4;
    [self setSubmitBtnSelected:YES];
}

- (IBAction)aliPayBtnAction:(id)sender {
    if (_payType != OTPayTypeAliPay) {
        _payType = OTPayTypeAliPay;
        [self setPayButton];
    }
}

- (IBAction)wechatBtnAction:(id)sender {
    if (_payType != OTPayTypeWeChat) {
        _payType = OTPayTypeWeChat;
        [self setPayButton];
    }
}

- (IBAction)submitBtnAction:(id)sender {
    switch (_chargeType) {
        case OTChargeTypeNone:
            
            [self showHUDErrorWithStatus:@"请选择充值金额"];
            
            break;
            
        case OTChargeTypeText:
            if (_textField.text.length > 5) {
                [self showHUDSuccessWithStatus:@"土豪，我们交个朋友吧"];
            } else {
                [self submitPayAction];
            }
            
            break;
        case OTChargeType1:
        case OTChargeType2:
        case OTChargeType3:
        case OTChargeType4:
            
            [self submitPayAction];
            
            break;
    }
}
/// 去支付
- (void)submitPayAction {
    if (![self canOpenAliPay] && ![self canOpenWeChat]) {
        [self showHUDErrorWithStatus:kErrorMessage];
        return;
    }
    
    NSString *money;
    if (_chargeType == OTChargeTypeText) {
        money = _textField.text;
    } else {
        money = [NSString stringWithFormat:@"%d", (int)_chargeType];
    }
    OTSignatureModel *signature = [[OTSignatureModel alloc] init];
    NSString *userID = [OTAccountManager sharedManger].userID;
    signature.userID = userID;
    signature.amount = money;
    [signature setHelloWorld:[OTAccountManager sharedManger].userModel.accessToken];
    NSString *orderNumber = [NSString stringWithFormat:@"%@_%.0f", userID, [[NSDate date] timeIntervalSince1970] * 1000];
    signature.orderNumber = orderNumber;
    NSString *param = signature.seriaParamString;
    WEAKSELF
    NSString *desc = [NSString stringWithFormat:@"充值 %@ 元", money];
#warning    // TODO 支付金额
    [self showHUD];
    
    [OTPayManager jsPayWithController:self description:desc goodsAmount:[NSString stringWithFormat:@"%d", (int)money.integerValue * 100] orderId:orderNumber attach:userID type:_payType completion:^(id result) {
        NSString *success = [NSString stringWithFormat:@"%@", result];
        if ([@"success" isEqualToString:success]) {
            [weakSelf showHUD];
            [[OTAccountManager sharedManger] rechargeParams:param completion:^(BOOL success, NSString *errMsg) {
                if (!success) {
                    [weakSelf showHUDErrorWithStatus:errMsg];
                    [weakSelf statisticsPaySuccess:NO amount:money.integerValue];
                } else {
                    // 充值成功，返回
                    [weakSelf showHUDSuccessWithStatus:@"充值成功，您会越来越幸运～"];
                    [weakSelf statisticsPaySuccess:YES amount:money.integerValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf dismissHUD];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                }
            }];
            
        } else {
            [weakSelf showHUDErrorWithStatus:@"充值失败了，您距离奖品又远了一分"];
            [weakSelf statisticsPaySuccess:NO amount:money.integerValue];
        }
        OTLog(@"【充值】%@", result);
    }];
    
}

- (void)statisticsPaySuccess:(BOOL)success amount:(NSInteger)amount {
    NSString * eventKey = success ? @"ot_recharge" : @"ot_recharge_failed";
    NSDictionary *dic = @{ @"userID": [OTAccountManager sharedManger].userID,
                           @"time" : [NSString stringWithFormat:@"%@", [NSDate date]],
                           @"amount": [NSString stringWithFormat:@"%@", @(amount)]};
    [OTStatistics event:eventKey attributes:dic];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextFiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *beString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL isValied = beString.integerValue > 0;
    if (isValied) {
        [self setChargeBtnDefault];
        _chargeType = OTChargeTypeText;
    } else {
        _chargeType = OTChargeTypeNone;
    }
    [self setSubmitBtnSelected:isValied];
    return YES;
}

@end

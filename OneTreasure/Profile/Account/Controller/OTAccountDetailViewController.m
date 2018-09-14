//
//  OTAccountDetailViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/24.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTAccountDetailViewController.h"

#import "OTAccountManager.h"
#import "OTUserModel.h"
#import "OTSignatureModel+OTDocument.h"
#import "OTSignatureModel+OTUploadAvatar.h"
#import "NSString+OTUtils.h"
#import "OTPhotoHelper.h"
#import "OTPhotoAccessManager.h"


/// section 种类
typedef NS_ENUM(NSInteger, OTAccountDetailSection) {
    OTAccountDetailSectionIcon,
    OTAccountDetailSectionAddress,
    
    OTAccountDetailSectionAll,
    
};

/// 地址section
typedef NS_ENUM(NSInteger, OTAccountDetailAddsRow) {
    OTAccountDetailAddsRowMobile,
    
    OTAccountDetailAddsRowNickName,
    
    OTAccountDetailAddsRowRealName,
    
    OTAccountDetailAddsRowAddress,
    
    OTAccountDetailAddsRowPostCode,
    
    OTAccountDetailAddsRowAll,
};

static NSString *const kAccountDetailIconCellID                                         = @"OTAccountDetailTableIconCellID";
static NSString *const kAccountDetailAddsCellID                                         = @"OTAccountDetailTableAddsCellID";



@interface OTAccountDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIView *footerView;

/// 地址section的cell名称
@property (nonatomic, strong) NSArray *addsnameArray;

@property (nonatomic, strong) OTSignatureModel *signModel;

@property (nonatomic, strong) OTPhotoHelper *helper;

@end


@implementation OTAccountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的资料";
    
    _addsnameArray = @[@"手机号码", @"昵称", @"真实姓名", @"联系地址", @"邮编"];
    
    [self initSignatureModel];
    [self setupTableViews];
}

- (void)setupTableViews {
    
    self.tableView.tableFooterView = self.footerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56.0)];
        _footerView.backgroundColor = [UIColor clearColor];
        UIButton *turnOffBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        turnOffBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [turnOffBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [turnOffBtn setTitle:@"保  存" forState:UIControlStateNormal];
        turnOffBtn.backgroundColor = RGB_COLOR(241, 96, 84, 1.0);
        turnOffBtn.frame = CGRectMake(20, 16.0, SCREEN_WIDTH - 40, 40.0);
        turnOffBtn.layer.cornerRadius = 4.0;
        turnOffBtn.layer.masksToBounds = YES;
        [turnOffBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:turnOffBtn];
    }
    return _footerView;
}

- (void)initSignatureModel {
    OTUserModel *userModel = [OTAccountManager sharedManger].userModel;
    _signModel = [[OTSignatureModel alloc] init];
    _signModel.mobile = userModel.mobile;
    if (![NSString isEmptyString:userModel.userID]) {
        _signModel.userID = userModel.userID;
    }
    if (![NSString isEmptyString:userModel.addressName]) {
        _signModel.addressName = userModel.addressName;
    }
    if (![NSString isEmptyString:userModel.realName]) {
        _signModel.realName = userModel.realName;
    }
    if (![NSString isEmptyString:userModel.nickName]) {
        _signModel.nickName = userModel.nickName;
    }
    if (![NSString isEmptyString:userModel.postCode]) {
        _signModel.postCode = userModel.postCode;
    }
    if (![NSString isEmptyString:userModel.accessToken]) {
        [_signModel setHelloWorld:userModel.accessToken];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)updoadAvatarWithData:(NSData *)data {
    
    OTSignatureModel *signature = [[OTSignatureModel alloc] init];
    [signature setHelloWorld:[OTAccountManager sharedManger].userModel.accessToken];
    signature.userID = [OTAccountManager sharedManger].userID;
    signature.avatarData = data;
    NSString *params = signature.seriaParamString;
    WEAKSELF
    [self showHUD];
    [[OTAccountManager sharedManger] uploadAvatarParams:params avatarData:data completion:^(BOOL success, NSString *errMsg) {
        if (success) {
            [weakSelf showHUDSuccessWithStatus:nil];
        } else {
            [weakSelf showHUDErrorWithStatus:errMsg];
        }
    }];
}

- (void)selectPhotoLibrary:(UIImagePickerControllerSourceType)type {
    if (type == UIImagePickerControllerSourceTypeCamera) {
        if (![OTPhotoAccessManager isHasAccessCallOnCamera]) {
            [self showHUDErrorWithStatus:@"请到设置->隐私->相机->开启「夺宝」权限!"];
            return;
        }
    } else {
        if (![OTPhotoAccessManager isHasAccessCallOnAlbum]) {
            [self showHUDErrorWithStatus:@"请到设置->隐私->相机->开启「夺宝」权限!"];
            return;
        }
    }
    WEAKSELF
    _helper = [[OTPhotoHelper alloc] init];
    [_helper showOnPickerViewControllerSourceType:type onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
        UIImage *images = [editingInfo objectForKey:UIImagePickerControllerEditedImage];
        if (images) {
            NSData *data = UIImageJPEGRepresentation(images, 0.3);
            [weakSelf updoadAvatarWithData:data];
        }
        
    }];
}
/// 选择
- (void)presentModifyAvators {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"修改头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    WEAKSELF
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectPhotoLibrary:UIImagePickerControllerSourceTypeCamera];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectPhotoLibrary:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

/**
 *  根据cell中的UITextField获取当前cell的index
 *
 *  @param sender 按钮
 *
 *  @return 当前的index
 */
- (NSIndexPath*)getIndexOfCellContentTextField:(UITextField*)sender {
    if (![sender isKindOfClass:[UITextField class]]) {
        return 0;
    }
    UIView * v = sender.superview.superview;
    if (![v isKindOfClass:[UITableViewCell class]]) {
        //ios 8.0以前 需要取三次才能取到 cell
        v = sender.superview.superview.superview;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)v];
    return indexPath;
}

#pragma mark - UITableViewDelegate/DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == OTAccountDetailSectionIcon) {
        return 80.0;
    } else {
        return 50.0;
    }
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return OTAccountDetailSectionAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == OTAccountDetailSectionIcon) {
        return 1;
    } else {
        return _addsnameArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == OTAccountDetailSectionIcon) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAccountDetailIconCellID];
        UIImageView *iconImg = [cell viewWithTag:100];
        OTUserModel  *userModel = [OTAccountManager sharedManger].userModel;
        NSString *iconName = userModel.avatorURLString;
        if ([NSString isEmptyString:iconName]) {
            NSString *endPhone = nil;
            if (userModel.mobile.length > 0) {
                endPhone = [NSString stringWithFormat:@"%d", (int)([userModel.mobile integerValue] % 20)];
            }
            iconName = [OTUserModel getRandomIconNameEndString:endPhone];
        }
        iconImg.image = [UIImage imageNamed:iconName];
        
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAccountDetailAddsCellID];
    UILabel *nameLab = [cell viewWithTag:300];
    nameLab.text = _addsnameArray[indexPath.row];
    UITextField *textField = [cell viewWithTag:310];
    textField.delegate = self;
    textField.enabled = (indexPath.row != OTAccountDetailAddsRowMobile);
    switch (indexPath.row) {
        case OTAccountDetailAddsRowMobile:
            textField.text = [OTAccountManager sharedManger].userModel.mobile;
            
            break;
            
        case OTAccountDetailAddsRowNickName:
            textField.placeholder = @"请输入昵称";
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.text = [OTAccountManager sharedManger].userModel.nickName;
            
            break;
            
        case OTAccountDetailAddsRowRealName:
            textField.placeholder = @"请输入名称";
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.text = [OTAccountManager sharedManger].userModel.realName;
            
            break;
            
        case OTAccountDetailAddsRowAddress:
            textField.placeholder = @"请输入详细地址";
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.text = [OTAccountManager sharedManger].userModel.addressName;
            
            break;
            
        case OTAccountDetailAddsRowPostCode:
            textField.placeholder = @"请输入邮编";
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.text = [OTAccountManager sharedManger].userModel.postCode;
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == OTAccountDetailSectionIcon;
//    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == OTAccountDetailSectionIcon) {
        return 10.0;
    }
    return 16.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == OTAccountDetailSectionAddress) {
        return 44 + 32;
    }
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == OTAccountDetailSectionIcon) {
        /// 设置头像
//        [self presentModifyAvators];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger row = [self getIndexOfCellContentTextField:textField].row;
    if (row == OTAccountDetailAddsRowPostCode) {
        NSString *beString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        return beString.length <= 6;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([NSString isEmptyString:textField.text]) {
        return;
    }
    NSInteger row = [self getIndexOfCellContentTextField:textField].row;
    if (row == OTAccountDetailAddsRowNickName) {
        // 昵称
        _signModel.nickName = textField.text;
    }
    if (row == OTAccountDetailAddsRowRealName) {
        // 姓名
        _signModel.realName = textField.text;
    }
    if (row == OTAccountDetailAddsRowAddress) {
        // 地址
        _signModel.addressName = textField.text;
    }
    if (row == OTAccountDetailAddsRowPostCode) {
        // 邮编
        _signModel.postCode = textField.text;
    }
}

/// 保存
- (void)saveBtnAction:(UIButton *)sender {
    
    NSString *params = _signModel.seriaParamString;
    WEAKSELF
    [[OTAccountManager sharedManger] modifyUserInfoParams:params completion:^(BOOL success, NSString *errMsg) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (success) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else {
                [weakSelf showHUDErrorWithStatus:errMsg];
            }
        });
    }];
}

@end

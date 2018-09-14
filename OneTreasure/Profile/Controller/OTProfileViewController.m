//
//  OTProfileViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTProfileViewController.h"
#import <StoreKit/StoreKit.h>

#import "OTBaseNavigationController.h"
#import "OTProfileAccountTableViewCell.h"
#import "OTProfileAccountCashTableViewCell.h"
#import "OTAccountDetailViewController.h"
#import "OTModifyPasswordViewController.h"

#import "OTNetworkManager.h"
#import "OTAccountManager.h"
#import "OTCommon.h"
#import "OTSignatureModel+OTDocument.h"
#import "OTUserModel.h"
#import "OTStatementView.h"




typedef NS_ENUM(NSInteger, OTProfileSectionType) {
    /// 个人信息
    OTProfileSectionTypeAccount,
    /// 记录
    OTProfileSectionTypeRecord,
    /// 关于
    OTProfileSectionTypeAbout,
    
    OTProfileSectionTypeAll,
};

static NSString *const kProfileAccountCellID                            = @"OTProfileTableViewAccountCellID";
static NSString *const kProfileAccountCashCellID                        = @"OTProfileTableViewCashCellID";
static NSString *const kProfileDefaultCellID                            = @"OTProfileTableViewDefaultCellID";
static NSString *const kProfileTurnOffCellID                            = @"OTProfileTableViewTurnOffCellID";

NSString *const kProfileAccountDetailSegueID                            = @"ot_profile_account_detail_segue_id";
NSString *const kProfileChargeSegueID                                   = @"ot_profile_charge_segue_id";


NSInteger const kDefaultTableViewCellHeight                             = 44.0;


@interface OTProfileViewController ()<UITableViewDelegate, UITableViewDataSource>
/// 主页面
@property (nonatomic, strong) UITableView *profileTableView;
/// 注销
@property (nonatomic, strong) UIView *footerView;

/// 苹果声明
@property (nonatomic, strong) OTStatementView *statementView;

@property (nonatomic, strong) NSArray *RecordArray;

@property (nonatomic, strong) NSArray *AboutArray;


@end

@implementation OTProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    
    [self.view addSubview:self.profileTableView];
//    [self.view addSubview:self.statementView];
    
    [self setupDatas];
    [self setupTableView];
    
    OTLog(@"=======%@", [OTAccountManager sharedManger].userID);
    Class storeVC = NSClassFromString(@"SKStoreReviewController");
    SEL requestReview = NSSelectorFromString(@"requestReview");
    if ([storeVC resolveClassMethod:requestReview]) {
        [SKStoreReviewController requestReview];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    
    [self updateUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)profileTableView {
    if (!_profileTableView) {
        _profileTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _profileTableView.delegate = self;
        _profileTableView.dataSource = self;
        _profileTableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
        _profileTableView.contentInset = UIEdgeInsetsMake(0, 0, 49 + 16, 0);
        _profileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _profileTableView.tableFooterView = self.footerView;
        self.tableView = _profileTableView;
    }
    return _profileTableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56.0)];
        _footerView.backgroundColor = [UIColor clearColor];
        UIButton *turnOffBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        turnOffBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [turnOffBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [turnOffBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        turnOffBtn.backgroundColor = RGB_COLOR(241, 96, 84, 1.0);
        turnOffBtn.frame = CGRectMake((SCREEN_WIDTH - 200) / 2, 16.0, 200, 40.0);
        turnOffBtn.layer.cornerRadius = 4.0;
        turnOffBtn.layer.masksToBounds = YES;
        [turnOffBtn addTarget:self action:@selector(turnOffBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:turnOffBtn];
    }
    return _footerView;
}

- (OTStatementView *)statementView {
    if (!_statementView) {
        _statementView = [[OTStatementView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49 - 30, SCREEN_WIDTH, 30)];
        WEAKSELF
        _statementView.StatementCloseAction = ^{
            [weakSelf.statementView removeFromSuperview];
        };
    }
    return _statementView;
}

- (void)setupTableView {
    
    [self.tableView registerNib:[OTProfileAccountTableViewCell getNib] forCellReuseIdentifier:kProfileAccountCellID];
    
}

- (void)setupDatas {
    _RecordArray = @[@"修改密码", @"夺宝记录", @"中奖纪录", @"充值记录"];
    _AboutArray = @[@"关于我们", @"常见问题"];
    
}

- (void)updateUserInfo {
    if ([OTAccountManager sharedManger].userID) {
        self.footerView.hidden = NO;
        // 用户登录了
        OTSignatureModel *model = [[OTSignatureModel alloc] init];
        [model setHelloWorld:[OTAccountManager sharedManger].userModel.accessToken];
        model.userID = [OTAccountManager sharedManger].userID;
        NSString *params = [model seriaParamString];
        WEAKSELF
        [[OTAccountManager sharedManger] getUserInfoParams:params completion:^(BOOL success, NSString *errMsg) {
           
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                   // 刷新UI
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:OTProfileSectionTypeAccount] withRowAnimation:UITableViewRowAnimationNone];
                });
            }
        }];
    } else {
        self.footerView.hidden = YES;
    }
}

- (void)segueToAccountDetailVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OTAccountStoryboard" bundle:nil];
    OTAccountDetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"OTAccountDetailViewController"];
    if (!detailVC) {
        return ;
    }
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)avatarBtnDidClick {
    WEAKSELF
    [[OTAccountManager sharedManger] accountSignInSuccess:^{
        
        [weakSelf segueToAccountDetailVC];
    } failed:^{
        
        [weakSelf segueToSignInViewController];
    }];
}

/// 余额点击事件
- (void)cashCellDidSelected {
    WEAKSELF
    [[OTAccountManager sharedManger] accountSignInSuccess:^{
        // 充值余额
        
        [weakSelf performSegueWithIdentifier:kProfileChargeSegueID sender:nil];
    } failed:^{
        // 去登录页面
        [weakSelf segueToSignInViewController];
    }];
}

/// 修改密码
- (void)changePwdCellDidSelected {
    WEAKSELF
    [[OTAccountManager sharedManger] accountSignInSuccess:^{
       // 修改密码
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OTAccountStoryboard" bundle:nil];
            OTModifyPasswordViewController *modifyVC = [storyboard instantiateViewControllerWithIdentifier:@"OTModifyPasswordViewController"];
            if (!modifyVC) {
                return ;
            }
            
            modifyVC.ModifiedPassword = ^(BOOL success) {
                if (success) {
                    // 修改密码，重新登录
                    [weakSelf segueToSignInViewController];
                }
            };
            [weakSelf.navigationController pushViewController:modifyVC animated:YES];
        });
    } failed:^{
        [weakSelf segueToSignInViewController];
    }];
}
/// 夺宝记录
- (void)purchaseHistoryCellDidSelected {
    WEAKSELF
    [[OTAccountManager sharedManger] accountSignInSuccess:^{
        // 夺宝
        [weakSelf segueToWebViewWithURLString:[URL_HOST stringByAppendingFormat:@"%@?uid=%@", URL_SHOP_HISTORY, [OTAccountManager sharedManger].userID] title:@"夺宝记录"];
    } failed:^{
        [weakSelf segueToSignInViewController];
    }];
}

/// 中奖纪录
- (void)luckHistoryCellDidSelected {
    WEAKSELF
    [[OTAccountManager sharedManger] accountSignInSuccess:^{
        [weakSelf segueToWebViewWithURLString:[URL_HOST stringByAppendingFormat:@"%@?uid=%@", URL_LUCK_HISTORY, [OTAccountManager sharedManger].userID] title:@"中奖纪录"];
    } failed:^{
        [weakSelf segueToSignInViewController];
    }];
}

/// 充值记录
- (void)rechargeHistoryCellDidSelected {
    WEAKSELF
    [[OTAccountManager sharedManger] accountSignInSuccess:^{
        [weakSelf segueToWebViewWithURLString:[URL_HOST stringByAppendingFormat:@"%@?uid=%@", URL_CHARGE_HISTORY, [OTAccountManager sharedManger].userID] title:@"充值记录"];
    } failed:^{
        [weakSelf segueToSignInViewController];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - UITableViewDelegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case OTProfileSectionTypeAccount:
            if (indexPath.row == 0) {
                return 180;
            }
            return kDefaultTableViewCellHeight;
            break;
        case OTProfileSectionTypeRecord:
            return kDefaultTableViewCellHeight;
            break;
        case OTProfileSectionTypeAbout:
            return kDefaultTableViewCellHeight;
            break;
        
    }
    return 0.5;
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return OTProfileSectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case OTProfileSectionTypeAccount:
            return 2;
            break;
        case OTProfileSectionTypeRecord:
            return _RecordArray.count;
            break;
        case OTProfileSectionTypeAbout:
            return _AboutArray.count;
            break;
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == OTProfileSectionTypeAccount) {
        if (indexPath.row == 0) {
            // 个人账户
            OTProfileAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileAccountCellID forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            cell.usrModel = [OTAccountManager sharedManger].userModel;
            WEAKSELF
            cell.iconBtnAction = ^{
                // 头像点击事件
                [weakSelf avatarBtnDidClick];
            };
            cell.signinBtnAction =^{
                // 登录点击事件
                [weakSelf segueToSignInViewController];
            };
            
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileAccountCashCellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kProfileAccountCashCellID];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.font = [UIFont systemFontOfSize:14.0];
                cell.textLabel.textColor = RGB_COLOR(121, 136, 158, 1.0);
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
                cell.detailTextLabel.textColor = RGB_COLOR(241, 96, 84, 1.0);
                cell.textLabel.text = @"账户余额";
            }
            if ([OTAccountManager sharedManger].userID) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [OTAccountManager sharedManger].userModel.credits];
            } else {
                cell.detailTextLabel.text = @"0";
            }
            
            return cell;
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileDefaultCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProfileDefaultCellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            cell.textLabel.textColor = RGB_COLOR(121, 136, 158, 1.0);
            
            UIView *sepreterView = [[UIView alloc] initWithFrame:CGRectMake(15, cell.bounds.size.height - 0.5, SCREEN_WIDTH - 15.0, 0.5)];
            sepreterView.backgroundColor = [UIColor lightGrayColor];
            [cell addSubview:sepreterView];
        }
        
        if (indexPath.section == OTProfileSectionTypeRecord) {
            cell.textLabel.text = _RecordArray[indexPath.row];
        } else {
            cell.textLabel.text = _AboutArray[indexPath.row];
        }
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == OTProfileSectionTypeAccount && indexPath.row == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (OTProfileSectionTypeAccount == indexPath.section) {
        if (indexPath.row == 1) {
            // 账户充值
            [self cashCellDidSelected];
        }
    } else if (OTProfileSectionTypeRecord == indexPath.section) {
        // 记录、密码
        if (indexPath.row == 0) {
            // 修改密码
            [self changePwdCellDidSelected];
        } else if(indexPath.row == 1) {
            // 夺宝记录
            [self purchaseHistoryCellDidSelected];
        } else if (indexPath.row == 2) {
            // 中奖纪录
            [self luckHistoryCellDidSelected];
        } else if (indexPath.row == 3) {
            // 充值记录
            [self rechargeHistoryCellDidSelected];
        }
    } else if (indexPath.section == OTProfileSectionTypeAbout) {
        if (indexPath.row == 2) {
            // 版本更新
            
            return;
        }
        NSString *formatURL;
        NSString *formatTitle;
        if (indexPath.row == 0) {
            // 关于我们
            formatTitle = @"关于我们";
            formatURL = [URL_HOST stringByAppendingFormat:@"%@?version=%@", URL_ABOUT_ME, app_version];
        } else if (indexPath.row == 1) {
            // Q&A
            formatURL = [URL_HOST stringByAppendingFormat:@"%@?version=%@", URL_NORMAL_QA, app_version];
            formatTitle = @"常见问题";
        }
        if ([OTAccountManager sharedManger].userID) {
            formatURL = [formatURL stringByAppendingFormat:@"&uid=%@", [OTAccountManager sharedManger].userID];
        }
        [self segueToWebViewWithURLString:formatURL title:formatTitle];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == OTProfileSectionTypeAccount) {
        return 0.1;
    }
    return 16.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset < -100) {
        OTLog(@"====%@", @(yOffset));
    }
}

- (void)turnOffBtnAction:(UIButton*)sender {
    /// 退出
    [[OTAccountManager sharedManger] deleteUserInfoWithID:nil];
    self.footerView.hidden = YES;
    [self.tableView reloadData];
    
}

@end

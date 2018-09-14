//
//  OTBaseViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/23.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTBaseViewController.h"
#import "OTWebViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import "OTStatistics.h"
//#import <FBRetainCycleDetector/FBRetainCycleDetector.h>


@interface OTBaseViewController ()

@end

@implementation OTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.49 green:0.55 blue:0.51 alpha:1.00]];
    [UINavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:20.0], NSForegroundColorAttributeName : [UIColor whiteColor] };
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    // 隐藏返回按钮的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

- (void)chectRetainCycle {
//    FBRetainCycleDetector *detector = [FBRetainCycleDetector new];
//    [detector addCandidate:self];
//    NSSet *retainCycles = [detector findRetainCyclesWithMaxCycleLength:100];
//    OTLog(@"==========\n%@", retainCycles);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem.title = @"";
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [OTStatistics beginLogPageView:NSStringFromClass([self class])];
    OTLog(@"++++++%@", NSStringFromClass([self class]));
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [OTStatistics endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HUD

- (void)setDefaultHUD {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
}

- (BOOL)hudIsVisible {
    return [SVProgressHUD isVisible];
}

- (void)showHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setDefaultHUD];
        [SVProgressHUD show];
    });
}

- (void)showHUDWithStatus:(NSString *)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:status];
    });
}

- (void)showHUDProgress:(float)progress status:(NSString*)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showProgress:progress status:status];
    });
}

- (void)showHUDInfoWithStatus:(NSString*)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:status];
    });
}

- (void)showHUDSuccessWithStatus:(NSString*)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:status];
    });
}

- (void)showHUDErrorWithStatus:(NSString*)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:status];
    });
}

- (void)dismissHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)dismissHUDWithDelay:(NSTimeInterval)delay {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismissWithDelay:delay];
    });
}

- (void)segueToWebViewWithURLString:(NSString *)string title:(NSString *)title {
    if (!string) {
        return;
    }
    OTWebViewModel *webModel = [[OTWebViewModel alloc] initWithURLString:string title:title];
    OTWebViewController *webVC = [[OTWebViewController alloc] init];
    webVC.webModel = webModel;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)segueToSignInViewController {
    UIStoryboard *accountStory = [UIStoryboard storyboardWithName:@"OTAccountStoryboard" bundle:nil];
    UINavigationController *accountRootVC = [accountStory instantiateViewControllerWithIdentifier:@"ot_account_navigation_vc_storyboard_id"];
    if (accountRootVC) {
        [self presentViewController:accountRootVC animated:YES completion:^{
            
        }];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

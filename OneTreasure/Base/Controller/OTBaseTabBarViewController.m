//
//  OTBaseTabBarViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/23.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTBaseTabBarViewController.h"

#import "OTCommon.h"
#import "NSString+OTUtils.h"


@interface OTBaseTabBarViewController ()

@end

@implementation OTBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectedIndex = 0;
    
    /// 购物车数量变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopcartCountNoti:) name:kOTShopCartCountPriceNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOTShopCartCountPriceNotification object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/// 购物车数量变化
- (void)shopcartCountNoti:(NSNotification *)noti {
    if (self.viewControllers.count >= 3) {
        UIViewController *shopVC = self.viewControllers[2];
        NSDictionary *dic = noti.userInfo;
        NSString *badgeValue = [NSString stringWithFormat:@"%@", dic[kOTShopCartNotifiCountValue]];
        if ([NSString isEmptyString:badgeValue] || badgeValue.integerValue == 0) {
            badgeValue = nil;
        } else if (badgeValue.integerValue >= 100) {
            badgeValue = @"99+";
        }
        shopVC.tabBarItem.badgeValue = badgeValue;
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
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

@end

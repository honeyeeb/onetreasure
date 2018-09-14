//
//  OTBaseViewController.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/23.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTBaseViewController : UIViewController

#pragma mark - HUD

- (BOOL)hudIsVisible;

- (void)showHUD;

- (void)showHUDWithStatus:(NSString *)status;

- (void)showHUDProgress:(float)progress status:(NSString*)status;

- (void)showHUDInfoWithStatus:(NSString*)status;

- (void)showHUDSuccessWithStatus:(NSString*)status;

- (void)showHUDErrorWithStatus:(NSString*)status;

- (void)dismissHUD;

- (void)dismissHUDWithDelay:(NSTimeInterval)delay;

/// 去一个web页面
- (void)segueToWebViewWithURLString:(NSString *)string title:(NSString *)title;

/// 展示登录页面
- (void)segueToSignInViewController;


@end

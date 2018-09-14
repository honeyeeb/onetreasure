//
//  OTSplashViewController.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/23.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTSplashViewController.h"

#import "OTCommon.h"
#import "OTNetworkManager.h"


NSString *const kSplashMainTabBarSegueID                = @"ot_splash_main_sugue_id";

@interface OTSplashViewController ()

@end

@implementation OTSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    ///
    __block BOOL enableNetwork = [[NSUserDefaults standardUserDefaults] boolForKey:OT_ENABLE_NETWORK];
    if (!enableNetwork) {
    
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            OTLog(@"【百度】:%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            if (data.length > 0) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:OT_ENABLE_NETWORK];
                enableNetwork = YES;
            }
        }];
        [task resume];
    }
    
    NSInteger time = enableNetwork ? 0 : 3;
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf performSegueWithIdentifier:kSplashMainTabBarSegueID sender:self];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

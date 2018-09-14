//
//  OTBaseNavigationController.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/23.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTBaseNavigationController.h"

@interface OTBaseNavigationController ()

@end

@implementation OTBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
    if(self.viewControllers.count > 0){
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
    if(viewController){
        return [super popToViewController:viewController animated:animated];
    }else{
        return nil;
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

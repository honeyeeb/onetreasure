//
//  OTShopCartEmptyView.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/10.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  购物车空页面

#import <UIKit/UIKit.h>

@interface OTShopCartEmptyView : UIView

/// 马上去夺宝
@property (nonatomic, copy) void (^emptyShopAction)();


@end

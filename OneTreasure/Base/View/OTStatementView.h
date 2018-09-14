//
//  OTStatementView.h
//  OneTreasure
//
//  Created by Frederic on 2017/1/13.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import <UIKit/UIKit.h>



/// 苹果声明页面
@interface OTStatementView : UIView

/// 关闭
@property (nonatomic, copy) void(^StatementCloseAction)(void);


@end

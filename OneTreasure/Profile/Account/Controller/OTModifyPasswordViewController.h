//
//  OTModifyPasswordViewController.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/24.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTBaseViewController.h"


/// 修改密码
@interface OTModifyPasswordViewController : OTBaseViewController

@property (nonatomic, copy) void (^ModifiedPassword)(BOOL success);

@end

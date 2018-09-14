//
//  OTProfileAccountTableViewCell.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/13.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//
//  个人帐户


#import "OTBaseTableViewCell.h"

@class OTUserModel;

@interface OTProfileAccountTableViewCell : OTBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgView;

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UIButton *signinBtn;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLab;

@property (copy, nonatomic) void(^iconBtnAction)(void);

@property (copy, nonatomic) void(^signinBtnAction)(void);

@property (weak, nonatomic) OTUserModel *usrModel;

@end

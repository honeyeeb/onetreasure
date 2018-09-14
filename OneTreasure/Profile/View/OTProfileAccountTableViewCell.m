//
//  OTProfileAccountTableViewCell.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/13.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTProfileAccountTableViewCell.h"

#import <SDWebImage/UIButton+WebCache.h>
#import "OTUserModel.h"


@interface OTProfileAccountTableViewCell ()

@property (nonatomic, copy) NSString *randomIconString;

@end

@implementation OTProfileAccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _signinBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _signinBtn.layer.borderWidth = 0.5;
    _signinBtn.layer.cornerRadius = 4.0;
    _signinBtn.layer.masksToBounds = YES;
    _signinBtn.hidden = YES;
    
    _iconBtn.layer.cornerRadius = 35.0;
    _iconBtn.layer.borderWidth = 3;
    _iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconBtn.layer.masksToBounds = YES;
    
//    UIImage *randomImg = [UIImage imageNamed:self.randomIconString];
//    [_iconBtn setImage:randomImg forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)randomIconString {
    if (!_randomIconString) {
        NSString *endPhone = nil;
        if (_usrModel.mobile) {
            endPhone = [NSString stringWithFormat:@"%d", (int)([_usrModel.mobile integerValue] % 20)];
        }
        _randomIconString = [OTUserModel getRandomIconNameEndString:endPhone];
    }
    return _randomIconString;
}

- (IBAction)iconBtnActions:(UIButton *)sender {
    if (self.iconBtnAction) {
        self.iconBtnAction();
    }
//    self.iconBtnAction = nil;
}

- (IBAction)signinBtnActions:(UIButton *)sender {
    if (self.signinBtnAction) {
        self.signinBtnAction();
    }
//    self.signinBtnAction = nil;
}

- (void)setUsrModel:(OTUserModel *)usrModel {
    _usrModel = usrModel;
    UIImage *randomImg = [UIImage imageNamed:self.randomIconString];
    if (usrModel.avatorURLString) {
        [_iconBtn sd_setImageWithURL:[NSURL URLWithString:usrModel.avatorURLString] forState:UIControlStateNormal placeholderImage:randomImg];
    } else {
        [_iconBtn setImage:randomImg forState:UIControlStateNormal];
    }
    if (!usrModel) {
        // 没有账号
        _nicknameLab.hidden = YES;
        _signinBtn.hidden = NO;
    } else {
        NSString *nickName = usrModel.nickName;
        if ([nickName isEqualToString:@""]) {
            nickName = usrModel.mobile;
        }
        _nicknameLab.hidden = NO;
        _nicknameLab.text = nickName;
        _signinBtn.hidden = YES;
    }
}

@end

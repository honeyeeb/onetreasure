//
//  OTShopCartEmptyView.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/10.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTShopCartEmptyView.h"

@interface OTShopCartEmptyView ()


@property (nonatomic, strong) UIImageView *defaultImgView;

@property (nonatomic, strong) UILabel *defaultLab;

@property (nonatomic, strong) UIButton *actionBtn;


@end

@implementation OTShopCartEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.defaultImgView];
    [self addSubview:self.defaultLab];
    [self addSubview:self.actionBtn];
}

- (UIImageView *)defaultImgView {
    if (!_defaultImgView) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shopcart_empty"]];
        imgView.frame = CGRectMake(0, 0, 100, 100);
        imgView.center = CGPointMake(self.center.x, 50);
        _defaultImgView = imgView;
    }
    return _defaultImgView;
}

- (UILabel *)defaultLab {
    if (!_defaultLab) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
        label.text = @"你的清单里空空如也";
        label.textColor = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1.00];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(self.defaultImgView.center.x, self.defaultImgView.frame.size.height + self.defaultImgView.frame.origin.y + 10);
        _defaultLab = label;
    }
    return _defaultLab;
}

- (UIButton *)actionBtn {
    if (!_actionBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"马上去夺宝" forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 120, 30);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.center = CGPointMake(self.defaultImgView.center.x, self.defaultLab.frame.origin.y + self.defaultLab.frame.size.height + 40);
        button.backgroundColor = [UIColor colorWithRed:0.94 green:0.46 blue:0.29 alpha:1.00];
        button.layer.cornerRadius = 4.0;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(shopCartBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _actionBtn = button;
    }
    return _actionBtn;
}

- (void)shopCartBtnAction {
    if (self.emptyShopAction) {
        self.emptyShopAction();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

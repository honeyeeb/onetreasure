//
//  OTGoodsToolsBar.m
//  OneTreasure
//
//  Created by Frederic on 2017/1/17.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTGoodsToolsBar.h"

@interface OTGoodsToolsBar ()
/// 加入购物车
@property (nonatomic, strong) UIButton *addShopCartBtn;
/// 直接购买
@property (nonatomic, strong) UIButton *directPayBtn;
/// 下一期
@property (nonatomic, strong) UILabel *finderLabel;


@end

@implementation OTGoodsToolsBar

- (instancetype)init {
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect dFrame = CGRectMake(self.frame.size.width / 2.0, 0, self.frame.size.width / 2.0, self.frame.size.height);
    _directPayBtn.frame = dFrame;
    
    CGRect aFrame = CGRectMake(0, 0, self.frame.size.width / 2.0, self.frame.size.height);
    _addShopCartBtn.frame = aFrame;
    
    _finderLabel.frame = aFrame;
}

- (UIButton *)addShopCartBtn {
    if (!_addShopCartBtn) {
        _addShopCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addShopCartBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _addShopCartBtn.backgroundColor = [UIColor colorWithRed:0.62 green:0.73 blue:0.26 alpha:1.00];
        [_addShopCartBtn addTarget:self action:@selector(addShopCartBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _addShopCartBtn.hidden = YES;
    }
    return _addShopCartBtn;
}

- (UIButton *)directPayBtn {
    if (!_directPayBtn) {
        _directPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_directPayBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _directPayBtn.backgroundColor = RGB_COLOR(248, 108, 108, 1.0);
        [_directPayBtn addTarget:self action:@selector(directPayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _directPayBtn.hidden = YES;
    }
    return _directPayBtn;
}

- (UILabel *)finderLabel {
    if (!_finderLabel) {
        _finderLabel = [[UILabel alloc] init];
        _finderLabel.textAlignment = NSTextAlignmentCenter;
        _finderLabel.hidden = YES;
    }
    return _finderLabel;
}

- (void)setupViews {
    
    [self addSubview:self.addShopCartBtn];
    [self addSubview:self.directPayBtn];
    [self addSubview:self.finderLabel];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
    if (_dataSource.count > 1) {
        NSString *stringD = _dataSource[1];
        _directPayBtn.hidden = NO;
        [_directPayBtn setTitle:stringD forState:UIControlStateNormal];
        
        NSString *stringA = _dataSource[0];
        if (_type == OTGoodsDetailToolsTypeNormal) {
            _addShopCartBtn.hidden = NO;
            _finderLabel.hidden = YES;
            [_addShopCartBtn setTitle:stringA forState:UIControlStateNormal];
        } else if (_type == OTGoodsDetailToolsTypeFinder) {
            _finderLabel.hidden = NO;
            _finderLabel.text = stringA;
            _addShopCartBtn.hidden = YES;
        }
    }

}

- (void)addShopCartBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
        [self.delegate didSelectedIndex:1];
    }
}

- (void)directPayBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
        [self.delegate didSelectedIndex:2];
    }
}

@end

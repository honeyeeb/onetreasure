//
//  OTCategoryCollectionViewCell.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTCategoryCollectionViewCell.h"

static CGFloat const LineViewH              = 2.0;

@implementation OTCategoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleBtn];
    [self.contentView addSubview:self.lineView];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.titleBtn.frame = self.bounds;
    self.lineView.frame = CGRectMake(0, self.frame.size.height - LineViewH, self.frame.size.width, LineViewH);
    self.lineView.hidden = !self.titleBtn.selected;
}

- (UIButton *)titleBtn {
    
    if (!_titleBtn) {
        
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleBtn.userInteractionEnabled = NO;
        [_titleBtn setTitleColor:[UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.00] forState:UIControlStateNormal];
        [_titleBtn setTitleColor:[UIColor colorWithRed:0.98 green:0.48 blue:0.29 alpha:1.00] forState:UIControlStateSelected];
    }
    return _titleBtn;
}

- (UIView *)lineView {
    
    if (!_lineView) {
        
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithRed:0.98 green:0.48 blue:0.29 alpha:1.00];
    }
    return _lineView;
}

@end

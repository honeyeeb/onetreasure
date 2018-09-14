//
//  OTStatementView.m
//  OneTreasure
//
//  Created by Frederic on 2017/1/13.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTStatementView.h"

@interface OTStatementView ()

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UILabel *statementLabel;

@end

@implementation OTStatementView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    
    CGRect btnFrame = CGRectMake(self.bounds.size.width - 20 - 5, (self.bounds.size.height - 20) / 2, 20, 20);
    self.closeBtn.frame = btnFrame;
    [self.closeBtn setImage:[UIImage imageNamed:@"ot_close_btn"] forState:UIControlStateNormal];
    
    CGRect labFrame = CGRectMake(5, 5, btnFrame.origin.x - 10, self.bounds.size.height - 10);
    self.statementLabel.frame = labFrame;
    
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _closeBtn;
}

- (UILabel *)statementLabel {
    if (!_statementLabel) {
        _statementLabel = [[UILabel alloc] init];
        _statementLabel.textColor = [UIColor lightTextColor];
        _statementLabel.font = [UIFont systemFontOfSize:13.0];
        _statementLabel.textAlignment = NSTextAlignmentCenter;
        _statementLabel.text = @"声明：所有商品活动与苹果公司(Apple Inc)无关";
    }
    return _statementLabel;
}

- (void)setupViews {
    
    [self addSubview:self.closeBtn];
    [self addSubview:self.statementLabel];
    
    self.backgroundColor = RGB_COLOR(100, 100, 100, 0.5);
}

- (void)closeButtonAction:(UIButton *)sender {
    if (self.StatementCloseAction) {
        self.StatementCloseAction();
    }
    self.StatementCloseAction = nil;
}


@end

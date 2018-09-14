//
//  OTShopCartRecommendHeaderView.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/11.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTShopCartRecommendHeaderView.h"

@interface OTShopCartRecommendHeaderView ()

@property (strong, nonatomic) IBOutlet UIView *headerContentView;

@end

@implementation OTShopCartRecommendHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setSubViews];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setSubViews];
    }
    return self;
}

- (UIView *)headerContentView {
    if (!_headerContentView) {
        _headerContentView = [[[NSBundle mainBundle] loadNibNamed:@"OTShopCartRecommendHeaderView" owner:self options:nil] objectAtIndex:0];
        [_headerContentView setBackgroundColor:[UIColor clearColor]];
    }
    return _headerContentView;
}

- (void)setSubViews {
    [self.contentView addSubview:self.headerContentView];
}

- (void)layoutSubviews {
    [self.headerContentView setFrame:self.bounds];
}

@end

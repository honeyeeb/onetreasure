//
//  OTShopCartPriceView.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/10.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTShopCartPriceView.h"

/// 支付按钮的长度
#define kPayButtonFrameWidth                            ( IS_IPHONE_6 ? 140 : 100)

/// 价格标签距离支付按钮水平距离
#define kPriceRightEdge                                 8

/// 价格标签高度
#define kPriceLabelFrameHeight                          30

/// 全选按钮的长度
#define kSelectAllButtonFrameWidth                      70

@interface OTShopCartPriceView ()

/**
 *  灰色半透明背景
 */
@property (strong, nonatomic) UIImageView *backGroundImg;
/**
 *  全选按钮
 */
@property (strong, nonatomic) UIButton *selectAllBtn;
/**
 *  支付按钮
 */
@property (strong, nonatomic) UIButton *payBtn;
/**
 *  价格信息标签
 */
@property (strong, nonatomic) UILabel *totalPriceLabel;
/**
 *  额外信息标签
 */
@property (strong, nonatomic) UILabel *detailLabel;


@end

@implementation OTShopCartPriceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // init subViews
        
        [self initPayViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initPayViews];
    }
    return self;
}

/**
 *  初始化页面元素
 */
- (void)initPayViews {
//    [self addSubview:self.backGroundImg];
    [self addSubview:self.selectAllBtn];
    [self addSubview:self.payBtn];
    [self addSubview:self.totalPriceLabel];
    [self addSubview:self.detailLabel];
    [self setBlurBackground];
}

/**
 *  灰色背景控件初始化
 *
 */
- (UIImageView *)backGroundImg {
    if (!_backGroundImg) {
        CGRect frame = self.bounds;
        frame.size.width -= kPayButtonFrameWidth;
        _backGroundImg = [[UIImageView alloc]initWithFrame:frame];
        [_backGroundImg setBackgroundColor:[UIColor clearColor]];
        
    }
    return _backGroundImg;
}
/**
 *  全选按钮控件初始化
 *
 */
- (UIButton *)selectAllBtn {
    if (!_selectAllBtn) {
        _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = self.bounds;
        frame.size.width = kSelectAllButtonFrameWidth;
        [_selectAllBtn setFrame:frame];
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAllBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 10, 15, 10)];
        [_selectAllBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_selectAllBtn setExclusiveTouch:YES];
        [_selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectAllBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_selectAllBtn addTarget:self action:@selector(selectAllBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self setSelectAll:NO];
    }
    return _selectAllBtn;
}
/**
 *  去支付按钮控件初始化
 *
 */
- (UIButton *)payBtn {
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        CGRect frame = self.bounds;
        frame.origin.x = self.bounds.size.width - kPayButtonFrameWidth;
        frame.size.width = kPayButtonFrameWidth;
        [_payBtn setFrame:frame];
        [_payBtn setExclusiveTouch:YES];
        [_payBtn addTarget:self action:@selector(payBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_payBtn setBackgroundColor:RGB_COLOR(248, 108, 108, 1.0)];
        [self setPayButtonText:0];
        
    }
    return _payBtn;
}
/**
 *  当前价格标签控件初始化
 *
 */
- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        CGFloat originX = self.selectAllBtn.frame.size.width + kPriceRightEdge;
        CGFloat width = self.bounds.size.width - originX - kPriceRightEdge - kPayButtonFrameWidth;
        CGRect frame = CGRectMake(originX, 0, width, kPriceLabelFrameHeight);
        _totalPriceLabel = [[UILabel alloc]initWithFrame:frame];
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
        [self setTotalPriceTextWithPrice:@"0"];
    }
    return _totalPriceLabel;
}
/**
 *  额外信息标签控件初始化
 *
 */
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        CGRect frame = CGRectMake(self.totalPriceLabel.frame.origin.x, self.totalPriceLabel.frame.size.height, self.totalPriceLabel.frame.size.width, self.bounds.size.height - kPriceLabelFrameHeight);
        _detailLabel = [[UILabel alloc] initWithFrame:frame];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [_detailLabel setFont:[UIFont systemFontOfSize:10]];
        [_detailLabel setTextColor:RGB_COLOR(153, 153, 153, 1.0)];
        [self setDetailText:@"不含优惠、不含运费"];
    }
    return _detailLabel;
}

#pragma mark - Action
/**
 *  选择全部商品按钮点击事件
 */
- (void)selectAllBtnAction {
    if ([self.delegate respondsToSelector:@selector(shopCartSelectedAllBtnAction)]) {
        [self.delegate shopCartSelectedAllBtnAction];
    }
}

/**
 *  去支付按钮点击事件
 */
- (void)payBtnAction {
    if ([self.delegate respondsToSelector:@selector(shopCartSubmitOrderBtnAction)]) {
        [self.delegate shopCartSubmitOrderBtnAction];
    }
}

/**
 *  设置是否选中 全选
 *
 *  @param select 是否
 */
- (void)setSelectAll:(BOOL)select {
    UIImage *normalImg;
    if (select) {
        normalImg = [UIImage imageNamed:@"shopping_select_yes_0"];
    } else {
        normalImg = [UIImage imageNamed:@"shopping_select_no_0"];
    }
    [_selectAllBtn setImage:normalImg forState:UIControlStateNormal];
}

- (void)setBlurBackground {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithFrame:self.bounds];
    effectView.effect = effect;
    [self insertSubview:effectView atIndex:0];
}

/**
 *  根据价格设置当前价格显示
 *
 *  @param price 价格
 */
- (void)setTotalPriceTextWithPrice:(NSString*)price {
    
    NSString *preString = @"共计:  ";
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc]initWithString:preString
                                                                                     attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName : [UIColor blackColor]}];
    
    NSMutableAttributedString *priceMutString = [OTShopCartPriceView setAtttrbleStr:price withFontRMB:12 bigFond:20 smallFond:12];
    [priceMutString addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(248, 108, 108, 1.0) range:NSMakeRange(0, priceMutString.length)];
    [mutableString appendAttributedString:priceMutString];
    
    
    [_totalPriceLabel setAttributedText:mutableString];
}

/**
 *  设置额外信息显示
 *
 *  @param text 额外信息
 */
- (void)setDetailText:(NSString*)text {
    NSString *message = [NSString stringWithFormat:@"%@", text];
    [_detailLabel setText:message];
}

/**
 *  设置去支付个数
 *
 *  @param count 数量
 */
- (void)setPayButtonText:(NSInteger)count {
    NSString *payText = [NSString stringWithFormat:@"去结算 (%d)", count <= 0 ? 0 : (int)count];
    // 字体颜色
    NSMutableAttributedString *mutable = [[NSMutableAttributedString alloc]initWithString:payText];
    [mutable addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, payText.length)];
    // 字体大小
    NSRange fontRange = [payText rangeOfString:@"去结算 "];
    [mutable addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:fontRange];
    
    [mutable addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(fontRange.length, payText.length - fontRange.length)];
    [_payBtn setAttributedTitle:mutable forState:UIControlStateNormal];
    
}

+ (NSMutableAttributedString*)setAtttrbleStr:(NSString *)str withFontRMB:(CGFloat)rmbFond bigFond:(CGFloat)bigFond smallFond:(CGFloat)smallFond {
    NSString *str1 = [NSString stringWithFormat:@"¥%@",str?:@""];
    if (str.length == 0) {
        str1 = @"";
    }
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:str1];
    if(str) {
        NSRange range = [str1 rangeOfString:@"¥"];
        [attriString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:rmbFond]} range:range];
        if(StringHasString(str, @".")) {
            NSArray *array = [str componentsSeparatedByString:@"."];
            if(array.count >1) {
                NSString *bigStr = [array objectAtIndex:0];
                NSString *smallStr = [array objectAtIndex:1];
                
                [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:bigFond] range:NSMakeRange(1, bigStr.length)];
                
                [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:smallFond] range:NSMakeRange(bigStr.length + 1, smallStr.length + 1)];
                
            }else{
                NSRange range1 = [str1 rangeOfString:str];
                [attriString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:bigFond]} range:range1];
            }
            
        }else{
            NSRange range1 = [str1 rangeOfString:str];
            [attriString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:bigFond]} range:range1];
        }
    }
    return attriString;
    
}

@end

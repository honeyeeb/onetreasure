//
//  OTFinderGoodsCollectionViewCell.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTFinderGoodsCollectionViewCell.h"

#import "OTFinderGoodsModel.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <MZTimerLabel/MZTimerLabel.h>

@interface OTFinderGoodsCollectionViewCell ()<MZTimerLabelDelegate>

@property (nonatomic, strong) MZTimerLabel *countDownLabel;

@end

@implementation OTFinderGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _timeViewBtn.layer.cornerRadius = 4.0;
    _timeViewBtn.layer.masksToBounds = YES;
    _timerViewLab.font = [UIFont systemFontOfSize:24.0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imgWidthContraint.constant = self.frame.size.height - 130;
    
}

- (void)setGoodsModel:(OTFinderGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    if (goodsModel) {
        _nameLab.text = goodsModel.gtitle;
        
        BOOL hideTimer = (goodsModel.stauts == 1);
        [self setTimerViewHeidden:hideTimer];
        if (hideTimer) {
            // 已经揭晓
            _winerNameLab.text = goodsModel.nickname;
            _numberCountLab.text = [NSString stringWithFormat:@"%ld", (long)goodsModel.cynumber];
            _luckNumberLab.text = goodsModel.xyhao;
            if (goodsModel.jxtime) {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"yy-MM-dd HH:mm:ss"];
                NSString *date = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:(goodsModel.jxtime / 1000)]];
                _timeNumberLab.text = date;
            }
        } else {
            // 倒计时
            _countDownLabel = [[MZTimerLabel alloc] initWithLabel:_timerViewLab andTimerType:MZTimerLabelTypeTimer];
            [_countDownLabel setTimeFormat:@"mm:ss:SS"];
            [_countDownLabel setCountDownTime:(goodsModel.jxtime / 1000 - [[NSDate date] timeIntervalSince1970])];
            WEAKSELF
            [_countDownLabel startWithEndingBlock:^(NSTimeInterval countTime) {
                weakSelf.timerViewLab.font = [UIFont systemFontOfSize:16.0];
                weakSelf.countDownLabel.timeLabel.text = @"请稍后，结果计算中......";
                if (weakSelf.countDownFinish) {
                    weakSelf.countDownFinish(weakSelf.goodsModel);
                }
            }];
        }
        [_imgView sd_setImageWithURL:[NSURL URLWithString:goodsModel.imgrul] placeholderImage:[UIImage imageNamed:@"good_default"]];
    }
}

- (void)setTimerViewHeidden:(BOOL)hidden {
    _timerView.hidden = hidden;
    _winerLab.hidden = !hidden;
    _winerNameLab.hidden = !hidden;
    _numberLab.hidden = !hidden;
    _numberCountLab.hidden = !hidden;
    _luckLab.hidden = !hidden;
    _luckNumberLab.hidden = !hidden;
    _timeLab.hidden = !hidden;
    _timeNumberLab.hidden = !hidden;
}

@end

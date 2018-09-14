//
//  OTHomeBannerCollectionCell.m
//  OneTreasure
//
//  Created by Frederic on 2017/1/13.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTHomeBannerCollectionCell.h"


@interface OTHomeBannerCollectionCell ()

@property (strong, nonatomic, readwrite) OTHomeBannerSubjectView *bannerView;


@end


@implementation OTHomeBannerCollectionCell

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
    
    self.bannerView.frame = self.bounds;
}

- (void)setupViews {
    
    self.bannerView = [[OTHomeBannerSubjectView alloc] init];
    self.bannerView.delegate = self.delegate;
    [self addSubview:self.bannerView];
}

- (void)setDelegate:(id<OTHomeBannerViewDelegate>)delegate {
    _delegate = delegate;
    self.bannerView.delegate = delegate;
}

@end

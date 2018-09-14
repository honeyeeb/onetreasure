//
//  OTHomeBannerCollectionCell.h
//  OneTreasure
//
//  Created by Frederic on 2017/1/13.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTBaseCollectionViewCell.h"

#import "OTHomeBannerSubjectView.h"


/// 首页广告条
@interface OTHomeBannerCollectionCell : OTBaseCollectionViewCell

@property (nonatomic, weak) id<OTHomeBannerViewDelegate> delegate;

@property (strong, nonatomic, readonly) OTHomeBannerSubjectView *bannerView;


@end

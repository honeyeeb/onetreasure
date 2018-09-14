//
//  OTHomeBannerSubjectView.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/25.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OTHomeBannerViewDelegate <NSObject>

@optional

- (void)didSelectedHomeBannerCellIndex:(NSInteger)index;

@end

/// 广告的信息
@interface OTBannerViewParam : NSObject
/// 图片URL地址
@property (nonatomic, copy) NSString *imgurl;
/// 图片标题
@property (nonatomic, copy) NSString *title;

@end

/**
 *  广告轮播View
 */
@interface OTHomeBannerSubjectView : UIView

@property (nonatomic, strong) id<OTHomeBannerViewDelegate>        delegate;
@property (nonatomic, strong) NSArray                             *subjectList;
@property (nonatomic, assign) BOOL                                isAutoScroll;

@end

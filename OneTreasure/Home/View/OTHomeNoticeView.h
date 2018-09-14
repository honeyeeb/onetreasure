//
//  OTHomeNoticeView.h
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OTNotifiViewDelegate <NSObject>

@optional

- (void)didSelectedNoticeCellIndexPath:(NSIndexPath *)indexPath;

@end

@interface OTHomeNoticeView : UIView

@property (nonatomic, weak) id<OTNotifiViewDelegate> delegate;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign, getter=isAutoScroll) BOOL autoScroll;

@end

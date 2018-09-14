//
//  OTGoodsToolsBar.h
//  OneTreasure
//
//  Created by Frederic on 2017/1/17.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OTGoodsDetailToolsType) {
    OTGoodsDetailToolsTypeNormal,
    OTGoodsDetailToolsTypeFinder,
};

@protocol OTGoodsToolBarDelegate <NSObject>

@optional
- (void)didSelectedIndex:(NSInteger)index;

@end


@interface OTGoodsToolsBar : UIView

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) OTGoodsDetailToolsType type;

@property (nonatomic, weak) id<OTGoodsToolBarDelegate> delegate;

@end

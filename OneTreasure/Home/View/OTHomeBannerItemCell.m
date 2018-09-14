//
//  OTHomeBannerItemCell.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/25.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTHomeBannerItemCell.h"

@implementation OTHomeBannerItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imageView];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    [self.imageView setImage:nil];
}

#pragma mark - setters and getters

- (UIImageView *)imageView {
    
    if(!_imageView){
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    
    return _imageView;
}
@end

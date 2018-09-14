//
//  OTPhotoHelper.h
//  OneTreasure
//
//  Created by Frederic on 2016/12/30.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^didFinishTakeMediaCompledBlock)(UIImage *image, NSDictionary *editingInfo);


@interface OTPhotoHelper : NSObject

/// 选择相册／拍照
- (void)showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController compled:(didFinishTakeMediaCompledBlock)compled;

@end

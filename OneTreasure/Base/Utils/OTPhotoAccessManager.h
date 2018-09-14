//
//  OTPhotoAccessManager.h
//  OneTreasure
//
//  Created by Frederic on 2017/1/16.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTPhotoAccessManager : NSObject

//判断应用是否有使用相机的权限
+ (BOOL)isHasAccessCallOnCamera;

//判断应用是否有访问相册的权限
+ (BOOL)isHasAccessCallOnAlbum;

@end

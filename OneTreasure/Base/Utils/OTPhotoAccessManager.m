//
//  OTPhotoAccessManager.m
//  OneTreasure
//
//  Created by Frederic on 2017/1/16.
//  Copyright © 2017年 honeyeeb. All rights reserved.
//

#import "OTPhotoAccessManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation OTPhotoAccessManager

//判断应用是否有使用相机的权限
+ (BOOL)isHasAccessCallOnCamera
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        //无权限
        return NO ;
    }
    return YES ;
}

//判断应用是否有访问相册的权限
+ (BOOL)isHasAccessCallOnAlbum
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
        //无权限
        return NO ;
    }
    return YES ;
}


@end

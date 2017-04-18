//
//  LHDCusstomAlbumCommonHeader.h
//  LHDCusstomAlbumCommonHeader
//
//  Created by 秦沙沙 on 16/3/10.
//  Copyright (c) 2015年 刘和东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 图片路径
#define LHDCusstomAlbumSrcName(file) [@"LHDCusstomAlbumAndCamera.bundle" stringByAppendingPathComponent:file]
/**
 *  新建相册的名字
 */
#define LHDCusstomAlbumGroupName @"Facemeet"

typedef void (^DismissViewControllerCompletionBlock)(BOOL yes);

/**
 *  点击完成的时候通知名称
 */
#define SelectedDoneBtnClicked @"SelectedDoneBtnClicked"

/**
 *  给View增加动画
 */
static inline void PhotoAddAnimationWithView(UIView * view)
{
    [view.layer removeAllAnimations];
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.05],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
}


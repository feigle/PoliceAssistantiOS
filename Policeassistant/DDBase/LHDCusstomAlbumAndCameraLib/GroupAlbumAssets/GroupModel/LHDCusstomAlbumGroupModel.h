//
//  LHDCusstomAlbumGroupModel.h
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/10.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


/**
 *  群组模型
 */
@interface LHDCusstomAlbumGroupModel : NSObject


/**
 *  分组的名字
 */
@property (nonatomic , copy) NSString *groupName;

/**
 *  组的真实名
 */
@property (nonatomic , copy) NSString *realGroupName;

/**
 *  缩略图
 */
@property (nonatomic , strong) UIImage *thumbImage;

/**
 *  组里面的图片个数
 */
@property (nonatomic , assign) NSInteger assetsCount;

/**
 *  类型
 */
@property (nonatomic , copy) NSString *type;

@property (nonatomic , strong) ALAssetsGroup *group;


@end

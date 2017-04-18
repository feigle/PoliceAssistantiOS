//
//  LHDCusstomAlbumAssetsViewController.h
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/10.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import "LHDBaseViewController.h"
#import "LHDCusstomAlbumGroupModel.h"

/**
 *  返回选取的值
 *
 *  @param thumImageArr     缩略图数组
 *  @param originImageArray 原图数组
 *  @param isChose          是否选择了图片
 */
typedef void (^GetAlbumThumImageAndOriginImageBlock)(LHDCusstomAlbumGroupModel * groupModel,NSArray * selectArr,NSArray *thumImageArr,NSArray * originImageArray,BOOL isChose);

/**
 *  图片单个分组管理控制器
 */
@interface LHDCusstomAlbumAssetsViewController : LHDBaseViewController

@property (nonatomic, strong) NSString * lastGroupName;
@property (nonatomic, assign) NSInteger maxCount;//最大选择的照片数量
@property (nonatomic, strong) NSMutableArray * selectedImageArray;//选择的照片数组
@property (nonatomic, assign) BOOL isNeedEditPhoto;//照完照片后,如果一张照片也会编辑图片
@property (nonatomic, weak) UIViewController * fromeViewController;//
@property (nonatomic, assign) BOOL  isHeader;//是不是头像，用于，图片剪切的正方形
/**宽度除以高度的 比例，默认是 0.56*/
@property (nonatomic, assign) CGFloat editWideHighRatio;
- (void)getImagesBlock:(GetAlbumThumImageAndOriginImageBlock)block;

- (void)show;


@end

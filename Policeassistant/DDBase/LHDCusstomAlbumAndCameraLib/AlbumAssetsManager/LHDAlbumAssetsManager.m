//
//  LHDAlbumAssetsManager.m
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/10.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import "LHDAlbumAssetsManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LHDCusstomAlbumGroupModel.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "LHDCusstomAlbumCommonHeader.h"
#import <Photos/PHAsset.h>

@interface LHDAlbumAssetsManager ()

@property (nonatomic , strong) ALAssetsLibrary *library;

@end

@implementation LHDAlbumAssetsManager

+ (ALAssetsLibrary *) defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,^
                  {
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

- (ALAssetsLibrary *)library
{
    if (nil == _library)
    {
        _library = [self.class defaultAssetsLibrary];
    }
    return _library;
}

+ (instancetype) defaultAlbum
{
    static dispatch_once_t once = 0;
    static LHDAlbumAssetsManager * manager = nil;
    dispatch_once(&once, ^{
        manager = [[LHDAlbumAssetsManager alloc] init];
    });
    return manager;
}

/**
 *  获取所有的图片
 */
- (void)getAllGroupWithAlbums:(callBackBlock)callBack
{
    [self getAllGroupWithAlbums:YES withSource:callBack];
}

/**
 *  获取所有的视频
 */
- (void)getAllGroupWithVideos:(callBackBlock)callBack
{
    [self getAllGroupWithAlbums:NO withSource:callBack];
}

/**
 *  从本地取相册资源的资源
 *
 *  @param isAllAlbum 取照片，还是视频
 *  @param callBack   返回值
 */
- (void)getAllGroupWithAlbums:(BOOL)isAllAlbum withSource:(callBackBlock)callBack
{
    
    // 获取当前应用对照片的访问授权状态
    
    NSMutableArray * groups = [NSMutableArray array];
    ALAssetsLibraryAccessFailureBlock failureblock =
    ^(NSError *myerror)
    {
        NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
//        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
//        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
//        NSString *tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
//        [MyAlertView alertMessage:tipTextWhenNoPhotosAuthorization];
        
        if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
        }else{
            NSLog(@"相册访问失败.");
        }
    };
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup * group, BOOL * stop){
        if (group) {
            if (isAllAlbum) {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            } else {
                [group setAssetsFilter:[ALAssetsFilter allVideos]];
            }
            LHDCusstomAlbumGroupModel * allbumGroup = [[LHDCusstomAlbumGroupModel alloc] init];
            allbumGroup.group = group;
            allbumGroup.groupName = [group valueForProperty:ALAssetsGroupPropertyName];;
            allbumGroup.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
            allbumGroup.assetsCount = [group numberOfAssets];
            [groups addObject:allbumGroup];
        } else {
            callBack(groups);
        }
    };
    NSInteger type = ALAssetsGroupAll;
    [self.library enumerateGroupsWithTypes:type usingBlock:resultsBlock failureBlock:failureblock];
}

- (void) getGroupPhotosWithGroup:(LHDCusstomAlbumGroupModel *)AlbumGroup finished:(callBackBlock)callBack
{
    NSMutableArray * assets = [NSMutableArray array];
    ALAssetsGroupEnumerationResultsBlock result = ^(ALAsset * assest, NSUInteger index, BOOL * stop) {
        if (assest) {
            [assets addObject:assest];
        } else {
            [assets sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSDate *date1 = [((ALAsset *)obj1) valueForProperty:ALAssetPropertyDate];
                NSDate *date2 = [((ALAsset *)obj2) valueForProperty:ALAssetPropertyDate];
                return [date2 compare:date1];
            }];
            callBack(assets);
        }
    };
    [AlbumGroup.group enumerateAssetsUsingBlock:result];
}

#pragma mark - 传入一个AssetsURL来获取UIImage
- (void) getAssetsPhotoWithURLs:(NSURL *) url callBack:(callBackBlock ) callBack{
    [self.library assetForURL:url resultBlock:^(ALAsset *asset) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            callBack([UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]);
            callBack(asset);
        });
    } failureBlock:nil];
}

- (void)saveImage:(UIImage *)image callBack:(callBackBlock)callBack
{
    [[LHDAlbumAssetsManager defaultAlbum].library saveImage:image toAlbum:LHDCusstomAlbumGroupName completion:^(NSURL *assetURL, NSError *error) {
        if (!error) {
            [self getAssetsPhotoWithURLs:assetURL callBack:^(id objc) {
                LHDCusstomAlbumAssetsModel * photoModel = [[LHDCusstomAlbumAssetsModel alloc] init];
                photoModel.asset = objc;
                callBack(photoModel);
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}
+ (void)saveImage:(UIImage *)image callBack:(callBackBlock)callBack
{
    [[LHDAlbumAssetsManager defaultAlbum].library saveImage:image toAlbum:LHDCusstomAlbumGroupName completion:^(NSURL *assetURL, NSError *error) {
        if (!error) {
            callBack(@YES);
        } else {
            callBack(@NO);
        }
    } failure:^(NSError *error) {
        callBack(@NO);
    }];
}

/**
 *  保存一张图片，得到 LHDCusstomAlbumAssetsModel一个模型
 *
 *  @param callBack LHDCusstomAlbumAssetsModel
 */
+ (void)saveImageData:(NSData *)imageData callBack:(callBackBlock) callBack
{
    [[LHDAlbumAssetsManager defaultAlbum].library saveImageData:imageData toAlbum:LHDCusstomAlbumGroupName metadata:nil completion:^(NSURL *assetURL, NSError *error) {
        
    } failure:^(NSError *error) {
        
    }];
}
@end

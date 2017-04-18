//
//  AliCloudUtil.h
//  DoorDuSDK
//
//  Created by user on 16/5/5.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <Foundation/Foundation.h>

//单图上传成功回调,objectKey为上传给阿里云对象的名称,需要将此名称返回给我们的服务器
typedef void(^AliCloudUploadSucceedBlock)           (NSString *objectKey);
//多图上传成功回调,objectKeys为上传给阿里云对象的名称,需要将这些名称返回给我们的服务器
typedef void(^AliCloudMultiUploadSucceedBlock)      (NSArray *objectKeys);
//上传失败回调
typedef void(^AliCloudUploadFailedBlock)            ();
//多图下载成功回调
typedef void(^AliCloudMultiDownloadSucceedBlock)    (NSArray *datas);
//单图下载成功回调
typedef void(^AliCloudSingleDownloadSucceedBlock)   (NSData *data);
//下载失败回调
typedef void(^AliCloudDownloadFailedBlock)          ();

typedef enum : NSUInteger {
    AliCloudDirTypeApkPackages,         //阿里云服务器apk包目录
    AliCloudDirTypeContactManagement,   //阿里云服务器联系物业目录
    AliCloudDirTypeHeadPortrait,        //阿里云服务器头像目录
    AliCloudDirTypeIdCards,             //阿里云服务器身份证目录
    AliCloudDirTypeVisitorImages        //阿里云服务器访客留影目录
} AliCloudDirType;

@interface AliCloudUtil : NSObject

- (instancetype)initWithUserID:(NSString *)userID deviceUDID:(NSString *)deviceUDID;

//单一上传
- (void)uploadImageWithimageData:(NSData *)data
                       imageName:(NSString *)imageName
                 AliCloudDirType:(AliCloudDirType)dirType
                    successBlock:(AliCloudUploadSucceedBlock)successBlock
                       failBlock:(AliCloudUploadFailedBlock)failBlock;

//单一下载
- (void)downloadImageWithName:(NSString *)imageName
              AliCloudDirType:(AliCloudDirType)dirType
                 successBlock:(AliCloudSingleDownloadSucceedBlock)successBlock
                    failBlock:(AliCloudDownloadFailedBlock)failBlock;

//批量上传
- (void)uploadImagesWithimageDatas:(NSArray *)datas
                        imageNames:(NSArray *)imageNames
                   AliCloudDirType:(AliCloudDirType)dirType
                     successBlock:(AliCloudMultiUploadSucceedBlock)successBlock
                        failBlock:(AliCloudUploadFailedBlock)failBlock;

//批量下载
- (void)downloadImagesWithNames:(NSArray *)imageNames
                AliCloudDirType:(AliCloudDirType)dirType
                   successBlock:(AliCloudMultiDownloadSucceedBlock)successBlock
                      failBlock:(AliCloudDownloadFailedBlock)failBlock;

@end

//
//  AliCloudUtil.m
//  DoorDuSDK
//
//  Created by user on 16/5/5.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "AliCloudUtil.h"

#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>
#import "DDAliCloudInfoClassModel.h"
#import "DDHttpRequest.h"

//阿里云OSS Bucket所在区域地址.
static NSString *const kAliCloud_EndPoint     = @"https://oss-cn-shenzhen.aliyuncs.com";
static NSString *const kAliCloud_BucketName   = @"doordustorage";

@implementation AliCloudUtil {
    
    //用户ID
    NSString *_userID;
    //设备唯一标识
    NSString *_deviceUDID;
    
    //阿里云OSS客户端
    OSSClient *_aliCloudClient;
    
    //阿里云临时访问密钥
    NSString *_aliCloudAccessKey;
    NSString *_aliCloudSecretKey;
    
    //阿里云安全令牌(用户判断客户端是否过期)
    NSString *_aliCloudSecurityToken;
    NSString *_aliCloudExpiration;
    
    //阿里云服务器apk包目录
    NSString *_apkPackagesDIR;
    //阿里云服务器联系物业目录
    NSString *_contactManagementDIR;
    //阿里云服务器头像目录
    NSString *_headPortraitDIR;
    //阿里云服务器身份证目录
    NSString *_idCardsDIR;
    //阿里云服务器访客留影目录
    NSString *_visitorImagesDIR;
    
    //保存上传的目录
    NSString *_dir;
    
}

- (instancetype)initWithUserID:(NSString *)userID deviceUDID:(NSString *)deviceUDID {
    
    if (self = [super init]) {
        
        _userID = userID;
        _deviceUDID = deviceUDID;
        
        _dir = @"";
        //初始化远程服务器目录
        _apkPackagesDIR = @"apk_packages";
        _contactManagementDIR = @"contact_management";
        _headPortraitDIR = @"head_portrait";
        _idCardsDIR = @"id_cards";
        _visitorImagesDIR = @"visitor_images";
        
        //初始化阿里云客户端(必须要初始化)
        [self initAliCloudClient];
    }
    return self;
}

#pragma mark - 初始化阿里云客户端
- (void)initAliCloudClient {
    
    /*!
     * 使用阿里云回调自动刷新客户端.
     * 当使用阿里云功能如上传、下载API时，会自动回调验证.
     */
    id <OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken *{
        
        //需要在这里实现获取一个FederationToken，并构造成OSSFederationToken对象返回.
        __block OSSFederationToken *token = nil;
        
        //设置阻塞
        OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        paramDic[@"user_id"] = _userID;
        paramDic[@"token"] = [DDUserDefault getLoginToken];
        paramDic[@"device_guid"] = _deviceUDID;
        paramDic[@"device_type"] = @"3";
        //从AppServer请求阿里云临时密钥和安全令牌
        
        [[self class] AliCloudRequestParms:[DDHttpRequest handleParametersSHA1:paramDic] success:^(DDAliCloudInfoClassModel *aliCloudModel, BOOL success) {
            if (success) {
                //阿里云服务器目录信息
                _apkPackagesDIR = aliCloudModel.apkPackagesDIR;
                _contactManagementDIR = aliCloudModel.contactManagementDIR;
                _headPortraitDIR = aliCloudModel.headPortraitDIR;
                _idCardsDIR = aliCloudModel.idCardsDIR;
                _visitorImagesDIR = aliCloudModel.visitorImagesDIR;
                
                //获取token
                token = [[OSSFederationToken alloc]init];
                token.tAccessKey = aliCloudModel.accessKeyId;
                token.tSecretKey = aliCloudModel.accessKeySecret;
                token.tToken = aliCloudModel.securityToken;
                token.expirationTimeInGMTFormat = aliCloudModel.expiration;
            }
            //移除阻塞
            [tcs setError:nil];
        }];
        //阻塞
        [tcs.task waitUntilFinished];
        
        return token;
    }];
    
    //设置阿里云客户端配置(此处可不配置，采用默认参数)
    OSSClientConfiguration *configuration = [OSSClientConfiguration new];
    configuration.maxRetryCount = 3; //网络请求遇到异常失败后的重试次数
    configuration.timeoutIntervalForRequest = 60.f; //网络请求的超时时间
    configuration.timeoutIntervalForResource = 24 * 60 * 60; //允许资源传输的最长时间
    
    //创建客户端
    _aliCloudClient = [[OSSClient alloc] initWithEndpoint:kAliCloud_EndPoint
                                       credentialProvider:credential
                                      clientConfiguration:configuration];
}

#pragma mark - 单一上传
- (void)uploadImageWithimageData:(NSData *)data
                       imageName:(NSString *)imageName
                 AliCloudDirType:(AliCloudDirType)dirType
                    successBlock:(AliCloudUploadSucceedBlock)successBlock
                       failBlock:(AliCloudUploadFailedBlock)failBlock{
    
    //目录
    switch (dirType) {
            
        case AliCloudDirTypeIdCards:
            _dir = _idCardsDIR;
            break;
            
        case AliCloudDirTypeApkPackages:
            _dir = _apkPackagesDIR;
            break;
            
        case AliCloudDirTypeHeadPortrait:
            _dir= _headPortraitDIR;
            break;
            
        case AliCloudDirTypeVisitorImages:
            _dir = _visitorImagesDIR;
            break;
            
        case AliCloudDirTypeContactManagement:
            _dir = _contactManagementDIR;
            break;
            
        default:
            _dir = @"";
            break;
    }
    
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    
    put.bucketName = kAliCloud_BucketName;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    //objectKey格式:上传的目录类型/userID/日期/图片的唯一标识
    NSString *objectKey = [NSString stringWithFormat:@"%@/%@/%@/%@", _dir, _userID, dateString, imageName];
    put.objectKey = objectKey;
    put.uploadingData = data;
    
    //以下可选字段的含义参考: https://docs.aliyun.com/#/pub/oss/api-reference/object&PutObject
    put.contentType = @"image/png";
    
    OSSTask *putTask =  [_aliCloudClient putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            
            //上传成功
            if (successBlock) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    successBlock(objectKey);
                });
            }
            
        } else {
            
            //上传失败
            if (failBlock) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    failBlock();
                });
            }
        }
        
        return nil;
    }];
    
}

#pragma mark - 单一下载
- (void)downloadImageWithName:(NSString *)imageName
              AliCloudDirType:(AliCloudDirType)dirType
                 successBlock:(AliCloudSingleDownloadSucceedBlock)successBlock
                    failBlock:(AliCloudDownloadFailedBlock)failBlock{
    
    //目录
    switch (dirType) {
            
        case AliCloudDirTypeIdCards:
            _dir = _idCardsDIR;
            break;
            
        case AliCloudDirTypeApkPackages:
            _dir = _apkPackagesDIR;
            break;
            
        case AliCloudDirTypeHeadPortrait:
            _dir= _headPortraitDIR;
            break;
            
        case AliCloudDirTypeVisitorImages:
            _dir = _visitorImagesDIR;
            break;
            
        case AliCloudDirTypeContactManagement:
            _dir = _contactManagementDIR;
            break;
            
        default:
            _dir = @"";
            break;
    }
    
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    
    //必填字段
    request.bucketName = kAliCloud_BucketName;
    request.objectKey = imageName;
    
    OSSTask * getTask = [_aliCloudClient getObject:request];
    [getTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            
            //下载成功
            OSSGetObjectResult * getResult = task.result;
            if (successBlock) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    successBlock(getResult.downloadedData);
                });
            }
            
        } else {
            
            //下载失败
            if (failBlock) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    failBlock();
                });
            }
        }
        
        return nil;
    }];
    
}

#pragma mark - 批量上传
- (void)uploadImagesWithimageDatas:(NSArray<NSData *> *)datas
                         imageNames:(NSArray *)imageNames
                   AliCloudDirType:(AliCloudDirType)dirType
                      successBlock:(AliCloudMultiUploadSucceedBlock)successBlock
                         failBlock:(AliCloudUploadFailedBlock)failBlock {
    
    if (datas.count != imageNames.count) {
        
        return;
    }
    
    __block int uploadCount = 0;    //上传次数
    __block BOOL isSucceed = YES;
    NSInteger count = datas.count;
    
    //信号量，用来线程同步
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    NSMutableArray *objectKeys = [NSMutableArray arrayWithArray:imageNames];
    
    for (NSInteger i = 0; i < count; i++) {
        
        [self uploadImageWithimageData:datas[i] imageName:imageNames[i] AliCloudDirType:dirType successBlock:^(NSString *objectKey){
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//加锁
            uploadCount += 1;
            [objectKeys replaceObjectAtIndex:[objectKeys indexOfObject:objectKey.lastPathComponent] withObject:objectKey];
            dispatch_semaphore_signal(semaphore);//解锁
            
            if (uploadCount == count) {
                
                if (isSucceed) {
                    
                    //批量上传成功
                    if (successBlock) {
                        
                        successBlock(objectKeys);
                    }
                }else {
                    
                    //批量上传失败
                    if (failBlock) {
                        
                        failBlock();
                    }
                }
            }
            
        } failBlock:^{
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//加锁
            uploadCount += 1;
            isSucceed = NO;
            dispatch_semaphore_signal(semaphore);//解锁
            
            if (uploadCount == count) {
                
                if (failBlock) {
                    
                    failBlock();
                }
            }
        }];
    }
}

#pragma mark - 批量下载
- (void)downloadImagesWithNames:(NSArray<NSString *> *)imageNames
                AliCloudDirType:(AliCloudDirType)dirType
                   successBlock:(AliCloudMultiDownloadSucceedBlock)successBlock
                      failBlock:(AliCloudDownloadFailedBlock)failBlock {
    
    __block int downloadCount = 0;    //下载次数
    __block BOOL isSucceed = YES;
    NSInteger count = imageNames.count;
    NSMutableArray<NSData *> *datas = [NSMutableArray array];
    
    for (int i = 0; i < imageNames.count; i++) {
        
        [self downloadImageWithName:imageNames[i] AliCloudDirType:dirType successBlock:^(NSData *data) {
            
            @synchronized (self) {
                
                downloadCount += 1;
                [datas addObject:data];
            }
            
            if (downloadCount == count) {
                
                if (isSucceed) {
                    
                    //批量下载成功
                    if (successBlock) {
                        
                        successBlock(datas);
                    }
                }else {
                    
                    //批量下载失败
                    if (failBlock) {
                        
                        failBlock();
                    }
                }
            }
            
        } failBlock:^{
            
            @synchronized (self) {
                
                downloadCount += 1;
                isSucceed = NO;
            }
            
            if (downloadCount == count) {
                
                if (failBlock) {
                    
                    failBlock();
                }
            }
            
        }];
    }
}

typedef void (^ResAliCloudInfoFinishedBlock) (DDAliCloudInfoClassModel *aliCloudModel,BOOL success);

+ (void)AliCloudRequestParms:(NSDictionary *)dict success:(ResAliCloudInfoFinishedBlock)finishedBlockblock
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //请求的url
    NSString *requestUrl = [DDLandlordBaseUrl stringByAppendingPathComponent:@"v3/tools/aliyun_tokens"];
    manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 501)];

    [manager GET:requestUrl parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
            finishedBlockblock(nil,NO);
            return ;
        }
        NSDictionary * dict  = (NSDictionary *)responseObject;
        if ([dict.allKeys containsObject:@"code"]) {//失败需要统一处理错误
            [DDHttpRequest handleErrorCode:[[dict[@"code"] toString] integerValue] errorMesage:dict[@"message"]];
            finishedBlockblock(nil,NO);
            return;
        }
        NSString *apkPackagesDIR = nil;
        NSString *contactManagementDIR = nil;
        NSString *headPortraitDIR = nil;
        NSString *idCardsDIR = nil;
        NSString *visitorImagesDIR = nil;
        
        NSString *accessKeySecret = nil;
        NSString *accessKeyId = nil;
        NSString *securityToken = nil;
        NSString *expiration = nil;
        NSDictionary *dic = responseObject;
        if ([dic.allKeys containsObject:@"token"]) {
            
            NSDictionary *tokenDic = dic[@"token"];
            if ([tokenDic isKindOfClass:[NSDictionary class]]) {
                
                if ([tokenDic.allKeys containsObject:@"Credentials"]) {
                    
                    NSDictionary *credentialsDic = [tokenDic objectForKey:@"Credentials"];
                    if (credentialsDic && [credentialsDic isKindOfClass:[NSDictionary class]]) {
                        
                        //获取accessKeySecret
                        if ([credentialsDic.allKeys containsObject:@"AccessKeySecret"] &&
                            [credentialsDic[@"AccessKeySecret"] isKindOfClass:[NSString class]]) {
                            
                            accessKeySecret = credentialsDic[@"AccessKeySecret"];
                        }
                        
                        //获取accessKeyId
                        if ([credentialsDic.allKeys containsObject:@"AccessKeyId"] &&
                            [credentialsDic[@"AccessKeyId"] isKindOfClass:[NSString class]]) {
                            
                            accessKeyId = credentialsDic[@"AccessKeyId"];
                        }
                        
                        //获取securityToken
                        if ([credentialsDic.allKeys containsObject:@"SecurityToken"] &&
                            [credentialsDic[@"SecurityToken"] isKindOfClass:[NSString class]]) {
                            
                            securityToken = credentialsDic[@"SecurityToken"];
                        }
                        
                        //获取token过期时间
                        if ([credentialsDic.allKeys containsObject:@"Expiration"] &&
                            [credentialsDic[@"Expiration"] isKindOfClass:[NSString class]]) {
                            
                            expiration = credentialsDic[@"Expiration"];
                        }
                    }
                }
            }
        }
        
        if ([dic.allKeys containsObject:@"remote_directory"]) {
            
            NSDictionary *dirDic = dic[@"remote_directory"];
            if ([dirDic isKindOfClass:[NSDictionary class]]) {
                
                if ([dirDic.allKeys containsObject:@"apk_packages"] &&
                    [dirDic[@"apk_packages"] isKindOfClass:[NSString class]]) {
                    
                    apkPackagesDIR = dirDic[@"apk_packages"];
                }
                
                if ([dirDic.allKeys containsObject:@"contact_management"] &&
                    [dirDic[@"contact_management"] isKindOfClass:[NSString class]]) {
                    
                    contactManagementDIR = dirDic[@"contact_management"];
                }
                
                if ([dirDic.allKeys containsObject:@"head_portrait"] &&
                    [dirDic[@"head_portrait"] isKindOfClass:[NSString class]]) {
                    
                    headPortraitDIR = dirDic[@"head_portrait"];
                }
                
                if ([dirDic.allKeys containsObject:@"id_cards"] &&
                    [dirDic[@"id_cards"] isKindOfClass:[NSString class]]) {
                    
                    idCardsDIR = dirDic[@"id_cards"];
                }
                
                if ([dirDic.allKeys containsObject:@"visitor_images"] &&
                    [dirDic[@"visitor_images"] isKindOfClass:[NSString class]]) {
                    
                    visitorImagesDIR = dirDic[@"visitor_images"];
                }
            }
        }
        DDAliCloudInfoClassModel * aliInfoClass = [[DDAliCloudInfoClassModel alloc] init];
        //目录信息
        aliInfoClass.apkPackagesDIR = apkPackagesDIR;
        aliInfoClass.contactManagementDIR = contactManagementDIR;
        aliInfoClass.headPortraitDIR = headPortraitDIR;
        aliInfoClass.idCardsDIR = idCardsDIR;
        aliInfoClass.visitorImagesDIR = visitorImagesDIR;
        //token 信息
        aliInfoClass.accessKeyId = accessKeyId;
        aliInfoClass.accessKeySecret = accessKeySecret;
        aliInfoClass.securityToken = securityToken;
        aliInfoClass.expiration = expiration;
        finishedBlockblock(aliInfoClass,YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finishedBlockblock(nil,NO);
    }];
}

@end

//
//  DDNetManger.h
//  Policeassistant
//
//  Created by DoorDu on 16/7/7.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#define DDNetManagerShare [DDNetManger sharedDDNetManager]

/*! 使用枚举NS_ENUM:区别可判断编译器是否支持新式枚举,支持就使用新的,否则使用旧的 */
typedef NS_ENUM(NSUInteger, DDNetworkStatus)
{
    /*! 未知网络 */
    DDNetworkStatusUnknown           = 0,
    /*! 没有网络 */
    DDNetworkStatusNotReachable,
    /*! 手机自带网络 */
    DDNetworkStatusReachableViaWWAN,
    /*! wifi */
    DDNetworkStatusReachableViaWiFi
};

/*！定义请求类型的枚举 */
typedef NS_ENUM(NSUInteger, DDHttpRequestType)
{
    /*! get请求 */
    DDHttpRequestTypeGet = 0,
    /*! post请求 */
    DDHttpRequestTypePost,
    /*! put请求 */
    DDHttpRequestTypePut,
    /*! delete请求 */
    DDHttpRequestTypeDelete

};
/*! 定义请求成功的block */
typedef void( ^ DDResponseSuccess)(id response);
/*! 定义请求失败的block */
typedef void( ^ DDResponseFail)(NSError *error);

/*! 定义上传进度block */
typedef void( ^ DDUploadProgress)(int64_t bytesProgress,
                                  int64_t totalBytesProgress);
/*! 定义下载进度block */
typedef void( ^ DDDownloadProgress)(int64_t bytesProgress,
                                    int64_t totalBytesProgress);

typedef NSURLSessionTask DDURLSessionTask;

@interface DDNetManger : NSObject
/*! 获取当前网络状态 */
@property (nonatomic, assign) DDNetworkStatus   netWorkStatus;

/*!
 *  获得全局唯一的网络请求实例单例方法
 *
 *  @return 网络请求类BANetManager单例
 */
+ (instancetype)sharedDDNetManager;

+ (AFHTTPSessionManager *)sharedAFManager;
/*!
 *  开启网络监测
 */
+ (void)ba_startNetWorkMonitoring;
/*!
 *  网络请求方法,block回调
 *
 *  @param type         get / post
 *  @param urlString    请求的地址
 *  @param paraments    请求的参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 *  @param progress 进度
 */
+ (DDURLSessionTask *)ba_requestWithType:(DDHttpRequestType)type
                           withUrlString:(NSString *)urlString
                          withParameters:(NSDictionary *)parameters
                        withSuccessBlock:(DDResponseSuccess)successBlock
                        withFailureBlock:(DDResponseFail)failureBlock
                                progress:(DDDownloadProgress)progress;

/*!
 *  上传图片(多图)
 *
 *  @param operations   上传图片预留参数---视具体情况而定 可移除
 *  @param imageArray   上传的图片数组
 *  @param urlString    上传的url
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 */
+ (DDURLSessionTask *)ba_uploadImageWithUrlString:(NSString *)urlString
                                       parameters:(NSDictionary *)parameters
                                   withImageArray:(NSArray *)imageArray
                                 withSuccessBlock:(DDResponseSuccess)successBlock
                                  withFailurBlock:(DDResponseFail)failureBlock
                               withUpLoadProgress:(DDUploadProgress)progress;

/*!
 *  视频上传
 *
 *  @param operations   上传视频预留参数---视具体情况而定 可移除
 *  @param videoPath    上传视频的本地沙河路径
 *  @param urlString     上传的url
 *  @param successBlock 成功的回调
 *  @param failureBlock 失败的回调
 *  @param progress     上传的进度
 */
+ (void)ba_uploadVideoWithUrlString:(NSString *)urlString
                         parameters:(NSDictionary *)parameters
                      withVideoPath:(NSString *)videoPath
                   withSuccessBlock:(DDResponseSuccess)successBlock
                   withFailureBlock:(DDResponseFail)failureBlock
                 withUploadProgress:(DDUploadProgress)progress;

/*!
 *  文件下载
 *
 *  @param operations   文件下载预留参数---视具体情况而定 可移除
 *  @param savePath     下载文件保存路径
 *  @param urlString        请求的url
 *  @param successBlock 下载文件成功的回调
 *  @param failureBlock 下载文件失败的回调
 *  @param progress     下载文件的进度显示
 */
+ (DDURLSessionTask *)ba_downLoadFileWithUrlString:(NSString *)urlString
                                        parameters:(NSDictionary *)parameters
                                      withSavaPath:(NSString *)savePath
                                  withSuccessBlock:(DDResponseSuccess)successBlock
                                  withFailureBlock:(DDResponseFail)failureBlock
                              withDownLoadProgress:(DDDownloadProgress)progress;


@end

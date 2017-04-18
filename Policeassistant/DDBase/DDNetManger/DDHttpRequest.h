//
//  DDHttpRequest.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/14.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import <Foundation/Foundation.h>

//NS_ASSUME_NONNULL_BEGIN
typedef void (^FBDownloadSuccessBlock)(NSData * requestData, NSDictionary * requestDict,NSInteger statusCode);

typedef void (^FBDownloadFailureBlock)(NSInteger statusCode,NSError *  error,NSString * errorMessage);

@interface DDHttpRequest : NSObject

/**
 *  post请求
 *
 *  @param urlString     网址，不是全部的
 *  @param dict          字典,可以为nil
 *  @param isNeed        是否需要状态栏的菊花
 *  @param successBlock 请求成功数据
 *  @param failureBlock 请求失败数据
 */
+ (void)postWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict isNeedNetworkIndicatorVisible:(BOOL)isNeed success:(FBDownloadSuccessBlock)successBlock failure:(FBDownloadFailureBlock)failureBlock;

/**
 *  post请求，默认含义状态栏的菊花
 *
 *  @param urlString     网址，不是全部的
 *  @param dict          字典,可以为nil
 *  @param successBlock 请求成功数据
 *  @param failureBlock 请求失败数据
 */
+ (void)postWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict success:(FBDownloadSuccessBlock)successBlock failure:(FBDownloadFailureBlock)failureBlock;

/**
 *  get请求
 *
 *  @param urlString     网址，不是全部的
 *  @param dict          字典,可以为nil
 *  @param isNeed        是否需要状态栏的菊花
 *  @param successBlock 请求成功数据
 *  @param failureBlock 请求失败数据
 */
+ (void)getWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict isNeedNetworkIndicatorVisible:(BOOL)isNeed success:(FBDownloadSuccessBlock)successBlock failure:(FBDownloadFailureBlock)failureBlock;

/**
 *  get请求，默认含义状态栏的菊花
 *
 *  @param urlString     网址，不是全部的
 *  @param dict          字典,可以为nil
 *  @param successBlock 请求成功数据
 *  @param failureBlock 请求失败数据
 */
+ (void)getWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict success:(FBDownloadSuccessBlock)successBlock failure:(FBDownloadFailureBlock)failureBlock;


/**
 *  put请求
 *
 *  @param urlString     网址，不是全部的
 *  @param dict          字典,可以为nil
 *  @param isNeed        是否需要状态栏的菊花
 *  @param successBlock 请求成功数据
 *  @param failureBlock 请求失败数据
 */
+ (void)putWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict isNeedNetworkIndicatorVisible:(BOOL)isNeed success:(FBDownloadSuccessBlock)successBlock failure:(FBDownloadFailureBlock)failureBlock;

/**
 *  put请求，默认含义状态栏的菊花
 *
 *  @param urlString     网址，不是全部的
 *  @param dict          字典,可以为nil
 *  @param successBlock 请求成功数据
 *  @param failureBlock 请求失败数据
 */
+ (void)putWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict success:(FBDownloadSuccessBlock)successBlock failure:(FBDownloadFailureBlock)failureBlock;

/**系统统一处理参数，加密*/
+ (NSDictionary *)handleParametersSHA1:(NSDictionary *)parameters;
/**这里统一处理错误编码，与返回的错误信息*/
+ (void)handleErrorCode:(NSInteger)errorCode errorMesage:(NSString *)errorMessage;

@end

//NS_ASSUME_NONNULL_END

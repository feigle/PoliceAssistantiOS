//
//  DDHttpRequest.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/14.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDHttpRequest.h"
#import "AFNetworking.h"
#import "iPhoneUUID.h"
#import "DDTools.h"

@implementation DDHttpRequest

/*!
 *  获得全局唯一的网络请求实例单例方法
 *
 *  @return 网络请求类BANetManager单例
 */
+ (instancetype)sharedDDHttpRequest
{
    static DDHttpRequest *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
+ (AFHTTPSessionManager *)sharedAFManager
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        
        /*! 设置请求超时时间 */
        manager.requestSerializer.timeoutInterval = 15;
        
        /*! 设置相应的缓存策略：此处选择不用加载也可以使用自动缓存【注：只有get方法才能用此缓存策略，NSURLRequestReturnCacheDataDontLoad】 */
        AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;
        manager.responseSerializer = response;
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        /*! 设置返回数据为json, 分别设置请求以及相应的序列化器 */
        
        
        /*! 设置apikey ------类似于自己应用中的tokken---此处仅仅作为测试使用*/
        //        [manager.requestSerializer setValue:apikey forHTTPHeaderField:@"apikey"];
        
        /*! 复杂的参数类型 需要使用json传值-设置请求内容的类型*/
        //        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        /*! 设置响应数据的基本了类型 */
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", nil];
        manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 501)];

        // https  参数配置
        manager.securityPolicy = [self securityPolicy];
    });
    return manager;
}

+ (void)postWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict isNeedNetworkIndicatorVisible:(BOOL)isNeed success:(FBDownloadSuccessBlock)successBlock failure:(FBDownloadFailureBlock)failureBlock
{
    if (isNeed) {
        UIApplication *application = [UIApplication sharedApplication];
        application.networkActivityIndicatorVisible = YES;
    }
    urlString = [urlString utf8EncodingString];
    AFHTTPSessionManager * manager = [[self class] sharedAFManager];
    [manager POST:urlString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress： %f",uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (isNeed) {
            UIApplication *application = [UIApplication sharedApplication];
            application.networkActivityIndicatorVisible = NO;
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dataDict = (NSDictionary *)responseObject;
            if ([dataDict.allKeys containsObject:@"code"]) {//失败需要统一处理错误
                failureBlock([[dataDict[@"code"] toString] integerValue],nil,dataDict[@"message"]);
                [[self class] handleErrorCode:[[dataDict[@"code"] toString] integerValue] errorMesage:dataDict[@"message"]];
            }  else {//这里一般都是正确的
                NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
                NSInteger statusCode = response.statusCode;
                successBlock(responseObject,responseObject,statusCode);
                [[self class] handleErrorCode:statusCode errorMesage:nil];
            }
        } else {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([dataDict isKindOfClass:[NSDictionary class]]) {
                if ([dataDict.allKeys containsObject:@"code"]) {//失败需要统一处理错误
                    failureBlock([[dataDict[@"code"] toString] integerValue],nil,dataDict[@"message"]);
                    [[self class] handleErrorCode:[[dataDict[@"code"] toString] integerValue] errorMesage:dataDict[@"message"]];
                }  else {
                    NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
                    NSInteger statusCode = response.statusCode;
                    successBlock(responseObject,responseObject,statusCode);
                    [[self class] handleErrorCode:statusCode errorMesage:nil];
                }
            }else {
                NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
                NSInteger statusCode = response.statusCode;
                failureBlock(statusCode,nil,nil);
                [[self class] handleErrorCode:statusCode errorMesage:nil];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (isNeed) {
            UIApplication *application = [UIApplication sharedApplication];
            application.networkActivityIndicatorVisible = NO;
        }
        NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = response.statusCode;
        NSLog(@"%@",error.userInfo);
        failureBlock(statusCode,error,nil);
        [[self class] handleErrorCode:statusCode errorMesage:nil];
    }];
}

+ (void)postWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict success:(FBDownloadSuccessBlock)successBlock failure:(FBDownloadFailureBlock)failureBlock
{
    [[self class]postWithUrlString:urlString parms:dict isNeedNetworkIndicatorVisible:YES success:successBlock failure:failureBlock];
}



/**
 *  get请求
 *
 *  @param urlString     网址，不是全部的
 *  @param dict          字典,可以为nil
 *  @param isNeed        是否需要状态栏的菊花
 *  @param successBlock 请求成功数据
 *  @param failureBlock 请求失败数据
 */
+ (void)getWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict isNeedNetworkIndicatorVisible:(BOOL)isNeed success:(FBDownloadSuccessBlock)successBlock failure:(FBDownloadFailureBlock)failureBlock
{
    if (isNeed) {
        UIApplication *application = [UIApplication sharedApplication];
        application.networkActivityIndicatorVisible = YES;
    }
    urlString = [urlString utf8EncodingString];
    AFHTTPSessionManager * manager = [[self class] sharedAFManager];
    [manager GET:urlString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress： %f",uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (isNeed) {
            UIApplication *application = [UIApplication sharedApplication];
            application.networkActivityIndicatorVisible = NO;
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dataDict = (NSDictionary *)responseObject;
            if ([dataDict.allKeys containsObject:@"code"]) {//失败需要统一处理错误
                failureBlock([[dataDict[@"code"] toString] integerValue],nil,dataDict[@"message"]);
                [[self class] handleErrorCode:[[dataDict[@"code"] toString] integerValue] errorMesage:dataDict[@"message"]];
            }  else {//这里一般都是正确的
                NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
                NSInteger statusCode = response.statusCode;
                successBlock(responseObject,responseObject,statusCode);
                [[self class] handleErrorCode:statusCode errorMesage:nil];
            }
        } else {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([dataDict isKindOfClass:[NSDictionary class]]) {
                if ([dataDict.allKeys containsObject:@"code"]) {//失败需要统一处理错误
                    failureBlock([[dataDict[@"code"] toString] integerValue],nil,dataDict[@"message"]);
                    [[self class] handleErrorCode:[[dataDict[@"code"] toString] integerValue] errorMesage:dataDict[@"message"]];
                }  else {
                    NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
                    NSInteger statusCode = response.statusCode;
                    successBlock(responseObject,responseObject,statusCode);
                    [[self class] handleErrorCode:statusCode errorMesage:nil];
                }
            }else {
                NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
                NSInteger statusCode = response.statusCode;
                failureBlock(statusCode,nil,nil);
                [[self class] handleErrorCode:statusCode errorMesage:nil];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (isNeed) {
            UIApplication *application = [UIApplication sharedApplication];
            application.networkActivityIndicatorVisible = NO;
        }
        NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = response.statusCode;
        failureBlock(statusCode,error,nil);
        [[self class] handleErrorCode:statusCode errorMesage:nil];
    }];
}

/**
 *  get请求，默认含义状态栏的菊花
 *
 *  @param urlString     网址，不是全部的
 *  @param dict          字典,可以为nil
 *  @param successBlock 请求成功数据
 *  @param failureBlock 请求失败数据
 */
+ (void)getWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict success:(FBDownloadSuccessBlock)successBlock failure:(FBDownloadFailureBlock)failureBlock
{
    [[self class] getWithUrlString:urlString parms:dict isNeedNetworkIndicatorVisible:YES success:successBlock failure:failureBlock];
}

/**
 *  put请求
 *
 *  @param urlString     网址，不是全部的
 *  @param dict          字典,可以为nil
 *  @param isNeed        是否需要状态栏的菊花
 *  @param successBlock 请求成功数据
 *  @param failureBlock 请求失败数据
 */
+ (void)putWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict isNeedNetworkIndicatorVisible:(BOOL)isNeed success:(FBDownloadSuccessBlock)successBlock failure:(FBDownloadFailureBlock)failureBlock
{
    if (isNeed) {
        UIApplication *application = [UIApplication sharedApplication];
        application.networkActivityIndicatorVisible = YES;
    }
    urlString = [urlString utf8EncodingString];
    AFHTTPSessionManager * manager = [[self class] sharedAFManager];
    [manager PUT:urlString parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (isNeed) {
            UIApplication *application = [UIApplication sharedApplication];
            application.networkActivityIndicatorVisible = NO;
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dataDict = (NSDictionary *)responseObject;
            if ([dataDict.allKeys containsObject:@"code"]) {//失败需要统一处理错误
                failureBlock([[dataDict[@"code"] toString] integerValue],nil,dataDict[@"message"]);
                [[self class] handleErrorCode:[[dataDict[@"code"] toString] integerValue] errorMesage:dataDict[@"message"]];
            }  else {//这里一般都是正确的
                NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
                NSInteger statusCode = response.statusCode;
                successBlock(responseObject,responseObject,statusCode);
                [[self class] handleErrorCode:statusCode errorMesage:nil];
            }
        } else {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([dataDict isKindOfClass:[NSDictionary class]]) {
                if ([dataDict.allKeys containsObject:@"code"]) {//失败需要统一处理错误
                    failureBlock([[dataDict[@"code"] toString] integerValue],nil,dataDict[@"message"]);
                    [[self class] handleErrorCode:[[dataDict[@"code"] toString] integerValue] errorMesage:dataDict[@"message"]];
                }  else {
                    NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
                    NSInteger statusCode = response.statusCode;
                    successBlock(responseObject,responseObject,statusCode);
                    [[self class] handleErrorCode:statusCode errorMesage:nil];
                }
            }else {
                NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
                NSInteger statusCode = response.statusCode;
                failureBlock(statusCode,nil,nil);
                [[self class] handleErrorCode:statusCode errorMesage:nil];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (isNeed) {
            UIApplication *application = [UIApplication sharedApplication];
            application.networkActivityIndicatorVisible = NO;
        }
        NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = response.statusCode;
        failureBlock(statusCode,error,nil);
        [[self class] handleErrorCode:statusCode errorMesage:nil];
    }];
}

/**
 *  put请求，默认含义状态栏的菊花
 *
 *  @param urlString     网址，不是全部的
 *  @param dict          字典,可以为nil
 *  @param successBlock 请求成功数据
 *  @param failureBlock 请求失败数据
 */
+ (void)putWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict success:(FBDownloadSuccessBlock)successBlock failure:(FBDownloadFailureBlock)failureBlock
{
    [[self class] putWithUrlString:urlString parms:dict isNeedNetworkIndicatorVisible:YES success:successBlock failure:failureBlock];
}


+ (AFSecurityPolicy *)securityPolicy
{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    return securityPolicy;
//    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"" ofType:@""];
//    NSData * certData = [NSData dataWithContentsOfFile:cerPath];
//    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    securityPolicy.allowInvalidCertificates = YES;
//    securityPolicy.validatesDomainName = NO;
//    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
//    return securityPolicy;
}
#pragma mark - 对参数统一 处理加密处理
+ (NSDictionary *)handleParametersSHA1:(NSDictionary *)parameters
{
    NSMutableDictionary * dict = [[self class] _commonParametersHandle:parameters];
    NSArray * allKeys = dict.allKeys;
    NSArray * sortArray = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString * requestStr = [NSMutableString new];
    NSMutableDictionary * newDict = [NSMutableDictionary dictionary];
    for (NSString * key in sortArray) {
        NSString * newKey = [key removeBlank];//除去空格
        id value = dict[key];
        id newValue = value;
        if ([value isKindOfClass:[NSString class]]) {
            newValue = [(NSString *)value removeBlank];//除去空格
        }
        [newDict setObject:newValue forKey:newKey];
        [requestStr appendFormat:@"%@=%@",newKey,newValue];
        if (![key isEqualToString:sortArray.lastObject]) {//最后一个
            [requestStr appendFormat:@"&"];
        }
    }
    NSString * base64SingStr = [requestStr base64EncodedString];
    NSString * base64Str = [NSString stringWithFormat:@"%@%@",base64SingStr,DDHttpRequestSecretKey];
    NSString * shaStrrr = [base64Str SHA1];
    dict[@"sign"] = shaStrrr;
    return dict;
}

+ (NSMutableDictionary *)_commonParametersHandle:(NSDictionary *)parameters
{
    NSMutableDictionary * dict = [self getCommonParameters];
    if (parameters) {
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            [dict addEntriesFromDictionary:parameters];
        }
    }
    return dict;
}
/**返回统一的编码*/
+ (NSMutableDictionary *)getCommonParameters
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"version"] = DDPoliceassistantVersion;
    dict[@"apptimestamp"] = [DDTools gainTimestamp];
    dict[@"guid"] = [iPhoneUUID getUUIDString];
    return dict;
}
/**这里统一处理错误编码，与返回的错误信息*/
+ (void)handleErrorCode:(NSInteger)errorCode errorMesage:(NSString *)errorMessage
{
    NSString * message = nil;
    switch (errorCode) {
        case 0://网络请求超时
        {
            message = @"网络请求超时";
        }
            break;
        case 400://请求失败，response body中会包含具体错误码
        {
        }
            break;
        case 401://认证失败
        {
        }
            break;
        case 403://无权访问（例如操作其他sdk下的用户）
        {
        }
            break;
        case 404://未找到资源
        {
            message = @"请稍后重试，网络请求错误";
        }
            break;
        case 426://需要用户重新登录
        case 10426://用户登录状态过期
        {
            message = errorMessage;
            [DDUserDefault setLogin:NO];
            [DDUserDefault setIdentityType:PoliceAssistantNoLoginType];
            [DDLandlordUserModel deleteMyself];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(PoliceAssistantNoLoginType)];
        }
            break;
        case 500://服务器内部出错
        {
            message = @"链接服务器错误，请重试";
        }
            break;
        case 10400://参数错误
        {
        }
            break;
        case 10401://基本认证失败
        {
            message = errorMessage;
        }
            break;
        case 10403://无权访问（例如操作其他sdk下的用户）
        {
        }
            break;
        case 10404://未找到资源
        {
        }
            break;
        case 10500://服务器内部出错 10505
        {
        }
            break;
        case 10505://签名验证失败
        {
            message = errorMessage;
        }
            break;
        case 11000://用户名不合法
        {
            message = errorMessage;
        }
            break;
        case 11001://用户名或密码错误
        {
            message = errorMessage;
        }
            break;
        case 11002://密码设置格式错误
        {
            message = errorMessage;
        }
            break;
        case 11003://旧密码错误
        {
            message = errorMessage;
        }
            break;
        case 11004://新密码和确认密码不一致
        {
            message = errorMessage;
        }
            break;
        case 11005://新密码和旧密码一样
        {
            message = errorMessage;
        }
            break;
        case 11006://无楼栋信息
        {
            message = errorMessage;
        }
            break;
        case 11007://房号为空
        {
            message = errorMessage;
        }
            break;
        case 11008://授权提交失败
        {
            message = errorMessage;
        }
            break;
        case 11009://授权记录为空
        {
            message = errorMessage;
        }
            break;
        case 11010://授权修改失败
        {
            
        }
            break;
        case 11011://不是房东，无权登录
        {
            message = errorMessage;
        }
            break;
        case 11012://密码修改失败
        {
            message = errorMessage;
        }
            break;
        case 11013://提交失败，手机号码已绑定其它身份证
        {
            message = errorMessage;
        }
            break;
        case 11014://授权审核失败
        {
            message = errorMessage;
        }
            break;
        case 11015://请不要重复开卡
        {
            message = errorMessage;
        }
            break;
        case 11016://请不要重复开卡
        {
            message = errorMessage;
        }
            break;
        case 11017://该房东下面无房产
        {
            message = errorMessage;
        }
            break;
        case 11018://请核实填写姓名与身份证是否为同一人
        {
            message = errorMessage;
        }
            break;
            
        default:
            break;
    }
    if (message) {
        [DDProgressHUD showCenterWithText:message duration:2.0];
    }
}

@end

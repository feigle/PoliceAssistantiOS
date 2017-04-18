//
//  DDFaceplusplusAPIManager.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/13.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDFaceplusplusAPIManager.h"

static  NSString const *  DDFaceplusplusAPIManagerAPIKey = @"rSIZGyUhfmRsfQqDgSoZH7bF23CC3CzA";
static  NSString const *  DDFaceplusplusAPIManagerAPISecret = @"sHc59bUE5jVUC0mAYmImMINujZJtHZ37";

@implementation DDFaceplusplusAPIManager

+ (void)uploadImageWithImage:(UIImage *)image finished:(DDFaceplusplusAPIUploadFileFinishedBlock)finishedBlock
{
    NSString * ddFaceplusplusAPIManagerAPURL = @"https://api-cn.faceplusplus.com/cardpp/v1/ocridcard";
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    //    manager.requestSerializer.timeoutInterval = 60*10;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"api_key"] = DDFaceplusplusAPIManagerAPIKey;
    dict[@"api_secret"] = DDFaceplusplusAPIManagerAPISecret;
//    dict[@"legality"] = @"1";
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    /**这里的image转 NSData*/
    NSData * imageData = [self returnIdentifyCardWithImage:image];
    WeakSelf
    [manager POST:ddFaceplusplusAPIManagerAPURL parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData
                                    name:@"image_file"
                                fileName:[NSString stringWithFormat:@"image_file"]
                                mimeType:@"image/jpeg/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress： %f\n",uploadProgress.fractionCompleted);
        NSLog(@"总大小：%lld,当前大小:%lld，uploadProgress ：%lld",uploadProgress.totalUnitCount,uploadProgress.completedUnitCount,uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        StrongSelf;
        [[strongSelf class] handleNSURLSessionDataTaskResponseCode:task.response];
        NSDictionary *dataDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {//不是字典
            dataDict = (NSDictionary *)responseObject;
        } else {//JSON序列化
            dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (![dataDict isKindOfClass:[NSDictionary class]]) {
                dataDict = nil;
            }
        }
        if (dataDict) {//判断是否是空
            if ([dataDict.allKeys containsObject:@"cards"]) {
                NSArray *  cardsArray = dataDict[@"cards"];
                if (cardsArray.count == 1) {//有一张是正确的，因为身份证是单张上传的
                    NSDictionary * cardDataDict = cardsArray[0];//取出数据
                    if ([[cardDataDict[@"type"] toString] isEqualToString:@"1"]) {//看看类型是不是身份证，是身份证，type == 1
                        if ([[cardDataDict[@"side"] toString] isEqualToString:@"front"]) {//判断身份证是正面
                            DDIdentifyCardSideFrontModel * model = [[DDIdentifyCardSideFrontModel alloc] initWithDictionary:cardDataDict error:nil];
                            finishedBlock(dataDict,IdentifyCardSideFrontType,model,nil);
                        } else {//判断身份证是反面
                            DDIdentifyCardSideBackModel * model = [[DDIdentifyCardSideBackModel alloc] initWithDictionary:cardDataDict error:nil];
                            finishedBlock(dataDict,IdentifyCardSideBackType,nil,model);
                        }
                    } else {//这里确认不是身份证了
                        finishedBlock(dataDict,IdentifyCardTypeErrorType,nil,nil);
                    }
                } else {
                    finishedBlock(dataDict,IdentifyCardTypeErrorType,nil,nil);
                }
            } else {
                finishedBlock(dataDict,IdentifyCardTypeErrorType,nil,nil);
            }
        } else {//返回不是身份证,dataDict为nil，说明网络请求失败了
            finishedBlock(nil,IdentifyCardTypeErrorType,nil,nil);
        }
        application.networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        StrongSelf
        application.networkActivityIndicatorVisible = NO;
        [[strongSelf class] handleNSURLSessionDataTaskResponseCode:task.response];
        finishedBlock(nil,IdentifyCardTypeErrorType,nil,nil);
    }];
}

+ (NSData *)returnIdentifyCardWithImage:(UIImage *)image
{
    NSData * imageData = nil;
    CGFloat imageSizeWidth = image.size.width;
    if (imageSizeWidth > 640) {
        imageData = [image resizePressImage2DataScale:0.7];
    }else if(imageSizeWidth <= 320){
        imageData = [image resizePressImage2DataScale:1.0];
    }else {
        imageData = [image resizePressImage2DataScale:0.8];
    }
    return imageData;
}

+ (void)handleNSURLSessionDataTaskResponseCode:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    switch (httpResponse.statusCode) {
        case 413:
        {
            NSLog(@"客户发送的请求大小超过了2MB限制");
        }
            break;
        case 500:
        {
            NSLog(@"服务器内部错误");
        }
            break;
        default:
            break;
    }
}

@end

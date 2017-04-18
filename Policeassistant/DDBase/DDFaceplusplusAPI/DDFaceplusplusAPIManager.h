//
//  DDFaceplusplusAPIManager.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/13.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDIdentifyCardSideFrontModel.h"
#import "DDIdentifyCardSideBackModel.h"


/**
 block回调
 @param requestDict 请求到的数据，
 @param sideType 身份证的正面或者反面
 @param frontModel 身份证的正面数据模型
 @param backModel 身份证的反面数据模型
 */
typedef void (^DDFaceplusplusAPIUploadFileFinishedBlock)(NSDictionary *requestDict,IdentifyCardSideType sideType,DDIdentifyCardSideFrontModel * frontModel,DDIdentifyCardSideBackModel * backModel);

/*** face++ 上传图片 ，检测身份证是否争取*/
@interface DDFaceplusplusAPIManager : NSObject

+ (void)uploadImageWithImage:(UIImage *)image finished:(DDFaceplusplusAPIUploadFileFinishedBlock)finishedBlock;

+ (NSData *)returnIdentifyCardWithImage:(UIImage *)image;

@end

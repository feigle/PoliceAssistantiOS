//
//  DDAliCloudInfoClassModel.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/16.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! @brief 该类包含“阿里云凭证和阿里云服务器目录”数据
 *
 */
@interface DDAliCloudInfoClassModel : NSObject

//阿里云服务器apk包目录
@property (strong, nonatomic) NSString *apkPackagesDIR;
//阿里云服务器联系物业目录
@property (strong, nonatomic) NSString *contactManagementDIR;
//阿里云服务器头像目录
@property (strong, nonatomic) NSString *headPortraitDIR;
//阿里云服务器身份证目录
@property (strong, nonatomic) NSString *idCardsDIR;
//阿里云服务器访客留影目录
@property (strong, nonatomic) NSString *visitorImagesDIR;

//token信息
@property (strong, nonatomic) NSString *accessKeyId;
@property (strong, nonatomic) NSString *accessKeySecret;
@property (strong, nonatomic) NSString *securityToken;
@property (strong, nonatomic) NSString *expiration;

@end

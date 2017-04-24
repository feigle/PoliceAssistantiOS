//
//  DDIdentifyCardSideBackModel.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/14.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDBaseModel.h"

/**身份证反面数据模型*/
@interface DDIdentifyCardSideBackModel : DDBaseModel

@property (nonatomic,copy) NSString * issued_by;//签发机关
@property (nonatomic,copy) NSString * side;//front/back 表示身份证的正面或者反面（illegal）
@property (nonatomic,copy) NSString * type;//证件类型，返回1，代表是身份证。
@property (nonatomic,copy) NSString * valid_date;//有效日期，格式为一个16位长度的字符串，表示内容如下YYYY.MM.DD-YYYY.MM.DD，或是YYYY.MM.DD-长期。

- (BOOL)checkValue;

@end

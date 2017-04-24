//
//  DDIdentifyCardSideFrontModel.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/14.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDBaseModel.h"

/**身份证正面数据模型*/
@interface DDIdentifyCardSideFrontModel : DDBaseModel

@property (nonatomic,copy) NSString * address;//住址
@property (nonatomic,copy) NSString * birthday;//生日，格式为YYYY-MM-DD
@property (nonatomic,copy) NSString * gender;//性别（男/女）
@property (nonatomic,copy) NSString * id_card_number;//身份证号
@property (nonatomic,copy) NSString * name;//姓名
@property (nonatomic,copy) NSString * race;//民族（汉字）
@property (nonatomic,copy) NSString * side;//front/back 表示身份证的正面或者反面（illegal）
@property (nonatomic,copy) NSString * type;//证件类型，返回1，代表是身份证。

- (BOOL)checkValue;

@end

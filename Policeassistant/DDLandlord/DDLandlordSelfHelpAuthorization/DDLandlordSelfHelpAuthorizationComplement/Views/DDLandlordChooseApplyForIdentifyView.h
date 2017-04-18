//
//  DDLandlordChooseApplyForIdentify.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/13.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDBaseView.h"

/**
 返回值

 @param title 返回的标题
 @param index 返回第几个，从零开始
 */
typedef void (^DDLandlordChooseApplyForIdentifyReturnDataBlock)(NSInteger index);


/**选择申请身份*/
@interface DDLandlordChooseApplyForIdentifyView : DDBaseView

- (instancetype)initWithDataArray:(NSArray *)dataArray;


- (void)getIdentifyDataBlock:(DDLandlordChooseApplyForIdentifyReturnDataBlock)block;

- (void)show;
- (void)dismiss;

@end

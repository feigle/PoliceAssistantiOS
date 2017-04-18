//
//  SystemBlockDefinitionHeader.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/7.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#ifndef SystemBlockDefinitionHeader_h
#define SystemBlockDefinitionHeader_h

typedef void (^CallBackRefreshDataBlock)(BOOL isNeed);
typedef void (^CallBackReturnObjectDataBlock)(id objc);

//当创建活动后，让列表页面调转到自己创建的活动详情页面
static NSString *const PushEventDetailsMyselfViewController = @"PushEventDetailsMyselfViewController";


#endif /* SystemBlockDefinitionHeader_h */

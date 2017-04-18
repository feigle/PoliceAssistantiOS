//
//  DDLandlordUserModel.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/14.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordHouseListModel.h"
@class AutoCoding;

/**判断房东是否已经登陆*/
#define landlordIsLoginSuccess landlordUserModel.isLogin

/**房东单例*/
#define landlordUserModel (DDLandlordUserModel *)[DDLandlordUserModel currentUser]

/**
 *  房东的单例，利用了AutoCoding的自动归档功能，非常方便简单
 */
@interface DDLandlordUserModel : NSObject<NSCopying, NSCoding>

/**是否已经登陆*/
@property (nonatomic,assign) BOOL isLogin;
@property (nonatomic,strong) NSString * user_name;//用户名
@property (nonatomic,strong) NSString * user_id;//用户ID
@property (nonatomic,strong) NSString * agent_name;//龙岗市公安局
/**[1=>'管理员',2=>'民警',3=>'协警',4=>'保安',5=>'物业',6=>'房东'];*/
@property (nonatomic,strong) NSString * identity_type_id;//
@property (nonatomic,strong) NSString * real_name;//真实姓名
@property (nonatomic,strong) NSString * area_name;//区域名称
@property (nonatomic,strong) NSString * token;//用户令牌

/**当前被选中的那个*/
@property (nonatomic,strong) DDLandlordHouseListModel * selectedModel;
/**房东 房产数组，数组里面是 DDLandlordHouseListModel 模型*/
@property (nonatomic,strong) NSArray * landlordHouseListDataArray;


/**获取当前用户*/
+ (id) currentUser;
/**保存当前用户*/
+ (void) saveMySelf;
/**恢复当前用户*/
+ (id) restoreMyself;
/**判断用户是否存在*/
+ (BOOL) isExistMyself;
/**删除用户*/
+ (void)deleteMyself;
/**把对象self拷贝到target*/
- (id)copyToObject:(id)target;

+ (void)refreshUserInfoData:(NSDictionary *)dict;

@end

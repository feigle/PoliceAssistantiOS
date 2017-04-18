//
//  DDTaskOrderVC.h
//  Policeassistant
//
//  Created by DoorDu on 16/7/8.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDBaseViewController.h"

@interface DDTaskOrderVC : DDBaseViewController
@property(nonatomic,strong)NSString *flag;
@property(nonatomic,strong)NSDictionary *changDic;
@property(copy,nonatomic)void (^ButtonClick)(NSString*);
@property(copy,nonatomic)void (^Successful)(NSString*);
@end

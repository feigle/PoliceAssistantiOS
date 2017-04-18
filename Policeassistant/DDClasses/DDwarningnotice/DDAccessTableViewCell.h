//
//  DDAccessTableViewCell.h
//  Policeassistant
//
//  Created by DoorDu on 16/6/29.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDAccessTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView * Iconimg;//头像
@property (nonatomic,strong) UIImageView * Veidoimg;//头像
@property (nonatomic,strong) UIImageView * flagimg;//标志图片
@property (nonatomic,strong) UILabel * TypeLab;//登记or离开
@property (nonatomic,strong) UILabel * TimeLab;//登记时间
@property (nonatomic,strong) UILabel * AddressLab;//登记时间
@property (nonatomic,strong) UIView * upline;//上面的线
@property (nonatomic,strong) UIView * downline;//下面的线
@property (nonatomic,strong) UIView * hengline;//横着的线
@property (nonatomic,strong) UIButton * btn1;
@property (nonatomic,strong) UIButton * btn;
@property (nonatomic,strong) UIView *view3;
@property (nonatomic,strong) UIView *view1;
@property (nonatomic,strong) NSString *owner;
- (void)adddic:(NSDictionary *)dic withtype:(NSString *)type;
@end

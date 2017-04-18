//
//  DDEmptyView.h
//  tabbar
//
//  Created by DoorDu on 16/7/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDEmptyView : UIView
@property(nonatomic,strong)UIImageView*iconView;
@property(nonatomic,strong)UILabel*stateLabel;
+(DDEmptyView*)shareNoDataView;
+(instancetype)noDataView;
/**
 *  没数据的占位符
 *
 *  @param aview 位置
 *  @param icon  图片
 *  @param state 标题
 */
-(void)showCenterWithSuperView:(UIView*)aview icon:(NSString*)icon state:(NSString*)state;
@end

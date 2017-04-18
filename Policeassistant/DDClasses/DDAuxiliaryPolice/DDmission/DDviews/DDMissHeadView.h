//
//  DDMissHeadView.h
//  Policeassistant
//
//  Created by DoorDu on 16/7/4.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDMissHeadView;
@protocol DDMissHeadViewDelegate <NSObject>
-(void)segmentView:(DDMissHeadView *)segmentView didSelectIndex:(NSInteger)index;

@end

@interface DDMissHeadView : UIView
@property (nonatomic) id<DDMissHeadViewDelegate>delegate;
@property (nonatomic) NSArray * titles;
@property (nonatomic) UIColor * titleColor;//标题字体颜色
@property (nonatomic) UIColor * selectColor;//标题字体选中颜色
@property (nonatomic) UIColor * titleBackgroundColor;//标题背景颜色
@property (nonatomic) int selectIndex;
@property (nonatomic) UIFont * titleFont;
@property (nonatomic) UIView * dotView;
@end

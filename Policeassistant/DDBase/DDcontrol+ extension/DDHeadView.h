//
//  DDHeadView.h
//  tabbar
//
//  Created by DoorDu on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDHeadView;
@protocol DDHeadViewDelegate <NSObject>
-(void)segmentView:(DDHeadView *)segmentView didSelectIndex:(NSInteger)index;
@end
@interface DDHeadView : UIView
@property (nonatomic) id <DDHeadViewDelegate>delegate;
@property (nonatomic) NSArray * titles;
@property (nonatomic) UIColor * titleColor;//标题字体颜色
@property (nonatomic) UIColor * selectColor;//标题字体选中颜色
@property (nonatomic) UIColor * titleBackgroundColor;//标题背景颜色
@property (nonatomic) int selectIndex;
@property (nonatomic) UIFont * titleFont;
@property (nonatomic) UIView * dotView;
@end
@interface UIView (Category)
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat w;
@property (nonatomic,assign) CGFloat h;
@end

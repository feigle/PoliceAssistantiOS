//
//  DDBaseView.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/7.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemBlockDefinitionHeader.h"

@interface DDBaseView : UIView

@property (nonatomic,weak) UIViewController * superViewController;

/**
 返回一个对象，数据回调
 */
@property (nonatomic,copy) CallBackReturnObjectDataBlock retrunObjectBlock;
- (void)returnObjectCallBlock:(__autoreleasing CallBackReturnObjectDataBlock)block;
/**
 是否需要刷新，数据回调
 */
@property (nonatomic,copy) CallBackRefreshDataBlock retrunRefreshBlock;
- (void)returnRefreshCallBlock:(__autoreleasing CallBackRefreshDataBlock)block;

- (void)pushVC:(UIViewController *)vc;

- (void)pushVC:(UIViewController *)vc animated:(BOOL)animated;


@end

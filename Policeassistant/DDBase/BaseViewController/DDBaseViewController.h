//
//  DDBaseViewController.h
//  Policeassistant
//
//  Created by DoorDu on 16/6/27.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemBlockDefinitionHeader.h"

NS_ASSUME_NONNULL_BEGIN


@interface DDBaseViewController : UIViewController

@property (nonatomic,weak) UIViewController * superViewController;

/**
 起始页 默认0
 */
@property (nonatomic,assign) NSInteger page;
/**
 起始行 默认10
 */
@property (nonatomic,assign) NSInteger pagesize;
/**
 数据总数
 */
@property (nonatomic,assign) NSInteger dataTotal;

/*
 是否加载到了最后一页，最后一页为YES，默认为NO
 */
@property (nonatomic,assign) BOOL isFinish;

/**
 是否是第一次请求数据，用于记录有些界面在第一次请求的时候需要 加载 HUD,默认是YES
 */
@property (nonatomic,assign) BOOL fistRequestData;


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

- (void)doBackAction;

@end
NS_ASSUME_NONNULL_END

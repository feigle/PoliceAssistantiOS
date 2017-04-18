//
//  UIView+LHDClickedHandle.h
//  刘和东
//
//  Created by 秦沙沙 on 2014/12/21.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LHDViewClickedHandleBlock)(id sender);

@interface UIView (LHDClickedHandle)

- (void)addLHDClickedHandle:(LHDViewClickedHandleBlock)clickedBlock;




@end

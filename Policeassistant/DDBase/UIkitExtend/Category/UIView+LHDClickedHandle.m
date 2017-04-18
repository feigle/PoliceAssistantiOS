//
//  UIView+LHDClickedHandle.m
//  刘和东
//
//  Created by 秦沙沙 on 2014/12/21.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import "UIView+LHDClickedHandle.h"

#import <objc/runtime.h>

static char const keyLHDViewClickedHandle;

@implementation UIView (LHDClickedHandle)

- (void)addLHDClickedHandle:(LHDViewClickedHandleBlock)clickedBlock;
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedHandle:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    if (clickedBlock) {
        objc_setAssociatedObject(self, &keyLHDViewClickedHandle, clickedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)clickedHandle:(UITapGestureRecognizer *)sender
{
    LHDViewClickedHandleBlock clickedHandleBlock = objc_getAssociatedObject(self, &keyLHDViewClickedHandle);
    if (clickedHandleBlock) {
        clickedHandleBlock(sender.view);
    }
}


@end

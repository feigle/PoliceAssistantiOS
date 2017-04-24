//
//  DDForbidOperationTextField.m
//  DoorDuProjectAssistant
//
//  Created by 刘和东 on 2017/4/21.
//  Copyright © 2017年 深圳市多度科技有限公司. All rights reserved.
//

#import "DDForbidOperationTextField.h"

@implementation DDForbidOperationTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:)) {//禁止粘贴
        return NO;
    }
    if (action == @selector(select:)) {//禁止选择
        return NO;
    }
    if (action == @selector(selectAll:)) {//禁止全选
        return NO;
    }
    if (action == @selector(copy:)) {//禁止复制
        return NO;
    }
    if (action == @selector(cut:)) {//禁止剪切
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

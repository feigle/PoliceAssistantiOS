//
//  DDButton.m
//  podtest
//
//  Created by DoorDu on 16/7/21.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDButton.h"
typedef void(^TouchBtn)(DDButton* btn);
@interface DDButton()
{
    TouchBtn  _touchBlock;
}

@end
@implementation DDButton

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title touchBlock:(void (^)(DDButton *))touchBlock{
    self=[super init];
    if (self) {
        self.frame=frame;
        _touchBlock = touchBlock;
        [self setTitle:title forState:UIControlStateNormal];
        [self setBackgroundColor:DaohangCOLOR];
        self.layer.masksToBounds = YES;
        self.titleLabel.font=[UIFont systemFontOfSize:18];
        self.layer.cornerRadius = 6;
        [self addTarget:self action:@selector(clickSelfBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)clickSelfBtn:(DDButton*)btn {
    _touchBlock(self);
}
@end

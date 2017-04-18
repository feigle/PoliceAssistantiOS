//
//  DDMovieHeadView.m
//  Policeassistant
//
//  Created by DoorDu on 16/9/8.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDMovieHeadView.h"

@implementation DDMovieHeadView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self resetAllSubviews];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnWidth = self.bounds.size.height;
    _backBtn.frame = CGRectMake(10.0, (btnWidth-30)/2, 70, 30);
    _scrollLabel.frame = CGRectMake(100, 0, KScreenWidth-110, self.bounds.size.height);
}

- (void)resetAllSubviews{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:_backBtn];
    [_backBtn setImage:[UIImage imageNamed:@"gobackBtn@3x"] forState:UIControlStateNormal];
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    
    _scrollLabel = [[UILabel alloc]init];
    _scrollLabel.backgroundColor = [UIColor clearColor];
    _scrollLabel.font = [UIFont systemFontOfSize:15.0];
    _scrollLabel.textColor = [UIColor whiteColor];
    _scrollLabel.text=@"人员出入记录详情";
    [self addSubview:_scrollLabel];
    
}

@end

//
//  DDMissHeadView.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/4.
//  Copyright © 2016年 DoorDu. All rights reserved.
//
#define BTag 10000
#import "DDMissHeadView.h"
@interface DDMissHeadView (){
    NSMutableArray *buttons;
    float wid;
}
@end
@implementation DDMissHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self ininViewData];
        [self initViews];
    }
    return self;
}
- (void)ininViewData{
    _titles = @[@"待受理",@"处理中",@"已完成"];
    _titleColor = TEXCOLOR;
    _selectColor = [UIColor whiteColor];
    _titleBackgroundColor = RGB(33, 34, 50);
    _titleFont = sysFont18;
}
- (void)initViews{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    buttons = [NSMutableArray array];
    wid = self.frame.size.width/(float)_titles.count;
    for (int i = 0; i < _titles.count; i++) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i * wid, 0, wid, self.frame.size.height - 6)];
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:_titleFont];
       // [btn setTitleColor:_titleColor forState:UIControlStateNormal];
       // [btn setTitleColor:_selectColor forState:UIControlStateSelected];
        btn.titleLabel.font=_titleFont;
        btn.tag = BTag + i;
        [btn addTarget:self action:@selector(segmentIndexSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (i == 0) {
            _dotView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-6, wid, 6)];
            _dotView.backgroundColor = RGB(100, 100, 112);
            [self addSubview:_dotView];
            btn.selected = YES;
        }
        [self addSubview:btn];
        [buttons addObject:btn];
        btn.backgroundColor= _titleBackgroundColor;
    }
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(wid, 0,1 , 60)];
    line.backgroundColor=UIColorFromRGB(0x4F4F4C);
    [self addSubview:line];
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(wid*2, 0,1 , 60)];
    line1.backgroundColor=UIColorFromRGB(0x4F4F4C);
    [self addSubview:line1];
    self.backgroundColor=_titleBackgroundColor;
}
#pragma mark --button方法--
- (void)segmentIndexSelected:(UIButton *)button{
    self.selectIndex = (int)button.tag -BTag;
    for (UIButton *btn in buttons) {
        btn.selected = NO;
    }
    button.selected = YES;
    [UIView animateWithDuration:0.2 animations:^{
        _dotView.frame=CGRectMake(button.frame.origin.x, _dotView.frame.origin.y, _dotView.frame.size.width, _dotView.frame.size.height);
    }];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(segmentView:didSelectIndex:)]) {
        [self.delegate segmentView:self didSelectIndex:self.selectIndex];
    }
}
#pragma mark --setter方法(默认值)--

-(void)setTitles:(NSArray *)titles{
    _titles = titles ? titles : @[@"1",@"2",@"3",@"4"];
    for (int i=0; i<_titles.count; i++) {
        UIButton *btn= buttons[i];
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        if (i==0) {
            NSString *content =[NSString stringWithFormat:@"%@",_titles[0]];
            [btn setAttributedTitle:[DDTools ChangColorWithNumbers:content WithTextColor:RGB(229, 33, 18) WithTextFont:18] forState:UIControlStateNormal] ;
            [btn setTitleColor:TEXCOLOR forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setAttributedTitle:[DDTools ChangColorWithNumbers:content WithTextColor:RGB(229, 33, 18) WithTextFont:18] forState:UIControlStateSelected] ;
        }else if (i==1){
            NSString *content =[NSString stringWithFormat:@"%@",_titles[1]];
            [btn setAttributedTitle:[DDTools ChangColorWithNumbers:content WithTextColor:RGB(255, 150, 0) WithTextFont:18] forState:UIControlStateNormal] ;
            [btn setTitleColor:TEXCOLOR forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setAttributedTitle:[DDTools ChangColorWithNumbers:content WithTextColor:RGB(255, 150, 0) WithTextFont:18] forState:UIControlStateSelected] ;
        }else if (i==2){
            NSString *content =[NSString stringWithFormat:@"%@",_titles[2]];
            [btn setAttributedTitle:[DDTools ChangColorWithNumbers:content WithTextColor:RGB(229, 33, 18) WithTextFont:18] forState:UIControlStateNormal] ;
            [btn setTitleColor:TEXCOLOR forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setAttributedTitle:[DDTools ChangColorWithNumbers:content WithTextColor:RGB(255, 150, 0) WithTextFont:18] forState:UIControlStateSelected] ;
        }
    }
}
//标题字体颜色
- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor ? titleColor : MAINTEX;
    for (int i=0; i<_titles.count; i++) {
        UIButton *btn= buttons[i];
        [btn setTitleColor:_titleColor forState:UIControlStateNormal];
    }
}
//标题字体选中颜色
- (void)setSelectColor:(UIColor *)selectColor{
    _selectColor = selectColor ? selectColor : DaohangCOLOR;
    for (int i=0; i<_titles.count; i++) {
        UIButton *btn= buttons[i];
        [btn setTitleColor:_selectColor forState:UIControlStateSelected];
    }
}
//标题背景颜色
- (void)setTitleBackgroundColor:(UIColor *)titleBackgroundColor{
    _titleBackgroundColor = titleBackgroundColor ? titleBackgroundColor : [UIColor whiteColor];
    self.backgroundColor= _titleBackgroundColor;
}
- (void)setSelectIndex:(int)selectIndex{
    _selectIndex = selectIndex;
}
- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont ? titleFont : sysFont14;
    for (int i=0; i<_titles.count; i++) {
        UIButton *btn= buttons[i];
        btn.titleLabel.font=_titleFont;
    }
}


@end

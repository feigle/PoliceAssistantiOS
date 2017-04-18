//
//  DDEmptyView.m
//  tabbar
//
//  Created by DoorDu on 16/7/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DDEmptyView.h"


@implementation DDEmptyView

-(UIImageView *)iconView{
    if (!_iconView) {
        _iconView=[[UIImageView alloc] init];
        _iconView.contentMode=UIViewContentModeScaleAspectFit;
        _iconView.userInteractionEnabled=YES;
        _iconView.frame=CGRectMake((KScreenWidth-158)/2, 85+64, 158, 158);
    }
    return _iconView;
}
-(UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconView.frame), KScreenWidth, 20)];
        _stateLabel.font=[UIFont systemFontOfSize:14];
        // _stateLabel.backgroundColor=[UIColor redColor];
        _stateLabel.textColor=TEXCOLOR;
        _stateLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _stateLabel;
}
+(DDEmptyView*)shareNoDataView{
    static DDEmptyView* instance;
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[DDEmptyView alloc] init];
        });
    }
    return instance;
}
+(instancetype)noDataView{
    return [[self alloc] init];
}
-(instancetype)init{
    if (self=[super init]) {
        [self addSubview:self.iconView];
        [self addSubview:self.stateLabel];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}
-(void)showCenterWithSuperView:(UIView*)aview icon:(NSString*)icon state:(NSString*)state{
    [self showSuper:aview icon:icon state:state];
    self.frame=aview.bounds;
}
#pragma mark----Method----
-(void)showSuper:(UIView*)aview icon:(NSString*)icon state:(NSString*)state {
    if (!aview){
        // 抛出异常
        NSException *excp = [NSException exceptionWithName:@"BJNoDataViewException" reason:@"未设置父视图。" userInfo:nil];
        [excp raise];
        return;
    };
    icon=icon? icon:@"no_data";
    self.backgroundColor=aview.backgroundColor;
    [aview insertSubview:self atIndex:0];//插在父视图中的最底层(看情况设置)
    self.iconView.image=[UIImage imageNamed:icon];
    self.stateLabel.text=state;
}


@end

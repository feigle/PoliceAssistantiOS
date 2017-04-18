//
//  DDProgressHUD.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/7.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDProgressHUD.h"
//Toast默认停留时间
#define ToastDispalyDuration 1.2f
//Toast到顶端/底端默认距离
#define ToastSpace 100.0f
//Toast背景颜色
#define ToastBackgroundColor [UIColor blackColor]
@interface DDProgressHUD ()
{
    UIButton *_contentView;
    CGFloat  _duration;
}
@end
@implementation DDProgressHUD
- (id)initWithText:(NSString *)text{
    if (self = [super init]) {
        
        UIFont *font = [UIFont boldSystemFontOfSize:18];
        NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
        CGRect rect=[text boundingRectWithSize:CGSizeMake(250,CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,rect.size.width + 40, rect.size.height+ 30)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = font;
        textLabel.text = text;
        textLabel.numberOfLines = 0;
        
        _contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];
        _contentView.layer.cornerRadius = 5.0f;
        _contentView.backgroundColor = RGBA(34, 34, 34, 0.7);
        [_contentView addSubview:textLabel];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_contentView addTarget:self action:@selector(toastTaped:) forControlEvents:UIControlEventTouchDown];
        _contentView.alpha = 0.0f;
        _duration = ToastDispalyDuration;
     //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    }
    
    return self;
}
- (void)setDuration:(CGFloat)duration{
    _duration = duration;
}
-(void)dismissToast{
    [_contentView removeFromSuperview];
}
-(void)toastTaped:(UIButton *)sender{
    [self hideAnimation];
}
//- (void)deviceOrientationDidChanged:(NSNotification *)notify{
//    [self hideAnimation];
//}
#pragma mark-中间显示
+ (void)showCenterWithText:(NSString *)text{
    [DDProgressHUD showCenterWithText:text duration:ToastDispalyDuration];
}

+ (void)showCenterWithText:(NSString *)text duration:(CGFloat)duration{
    DDProgressHUD *toast = [[DDProgressHUD alloc] initWithText:text];
    [toast setDuration:duration];
    [toast show];
}
- (void)show{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    _contentView.center = window.center;
    [window  addSubview:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];
}
-(void)showAnimation{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    _contentView.alpha = 1.0f;
    [UIView commitAnimations];
}-(void)hideAnimation{
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    _contentView.alpha = 0.0f;
    [UIView commitAnimations];
}

@end

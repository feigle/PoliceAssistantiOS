//
//  LHDPopView.m
//  刘和东
//
//  Created by 刘和东 on 2015/10/27.
//  Copyright © 2015年 刘和东. All rights reserved.
//

#import "LHDPopView.h"
#import <objc/runtime.h>
#import "AppDelegate.h"

// convert degrees to radians
float DegreesToRadians(float angle) {
    return angle*M_PI/180;
}


@interface LHDPopView ()

@property (nonatomic, strong, readonly) UIWindow *overlayWindow;


/** 展示内容的view*/
@property (nonatomic,weak) UIView * contentView;

@property (nonatomic,assign) LHDPopViewBackgroundStyle style;

/** 遮罩层*/
@property (nonatomic,strong) UIView * maskView;
/** 边距*/
@property (nonatomic,assign) CGFloat popViewMargin;
/** 箭头的高度*/
@property (nonatomic,assign) CGFloat popViewArrowHeight;
/** 箭头的宽度*/
@property (nonatomic,assign) CGFloat popViewArrowWidth;
/** 箭头的圆角Radius（顶尖处）*/
@property (nonatomic,assign) CGFloat arrowCornerRadius;
/** 箭头与正方体连接处圆角Radius（顶尖处）*/
@property (nonatomic,assign) CGFloat arrowJoinCornerRadius;
/** 整个内容的圆角Radius*/
@property (nonatomic,assign) CGFloat contentCornerRadius;



@end

@implementation LHDPopView

@synthesize overlayWindow;

- (instancetype)initWithContentView:(UIView *)contentView withStyle:(LHDPopViewBackgroundStyle)style
{
    self = [super init];
    if (self) {
        _contentView = contentView;
        _style = style;
        [self addSubview:_contentView];
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.popViewArrowHeight = 13.f;
    self.popViewArrowWidth = 26.f;
    self.contentCornerRadius = 4.f;
    self.arrowCornerRadius = 1.5f;
    self.arrowJoinCornerRadius = 3.f;
    self.popViewMargin = 10.0;
    self.backgroundColor = [UIColor whiteColor];
}

/**fromView 箭头指向的View*/
- (void)showFromView:(UIView *)fromView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect fromViewRect = [self.overlayWindow convertRect:fromView.frame fromView:fromView.superview];
        CGPoint fromViewCenterPoint = CGPointMake(CGRectGetMidX(fromViewRect), CGRectGetMaxY(fromViewRect));
        [self showFromPoint:fromViewCenterPoint];
    });
}

/**fromPoint 箭头指向的Point*/
- (void)showFromPoint:(CGPoint)fromPoint
{
    /**判断箭头是否是向上*/
    BOOL arrowDirectionUp = (KScreenHeight-(fromPoint.y+self.contentView.height+self.popViewArrowHeight+self.popViewMargin))>0;
    
    
    // 如果箭头指向的点过于偏左或者过于偏右则需要重新调整箭头 x 轴的坐标
    CGFloat minHorizontalEdge = self.popViewMargin + self.contentCornerRadius + self.popViewArrowWidth/2;
    if (fromPoint.x < minHorizontalEdge) {
        fromPoint.x = minHorizontalEdge;
    }
    if (KScreenWidth - fromPoint.x < minHorizontalEdge) {
        fromPoint.x = KScreenWidth - minHorizontalEdge;
    }
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = self.contentCornerRadius;
    self.contentView.x = 1;
    self.contentView.top = arrowDirectionUp?(self.popViewArrowHeight+1):1;
//    self.contentView.backgroundColor = [UIColor orangeColor];
#pragma mark - 宽度
    CGFloat currentWidth = (self.contentView.width>(KScreenWidth-self.popViewMargin*2)?(KScreenWidth-self.popViewMargin*2):self.contentView.width)+2;
#pragma mark - 高度
    CGFloat currentHeight = self.contentView.height+self.popViewArrowHeight+2;
    CGFloat maxHeight = arrowDirectionUp?(KScreenHeight-self.popViewMargin):(fromPoint.y);
    if (currentHeight > maxHeight) {
        currentHeight = maxHeight;
        self.contentView.height = currentHeight;
    }
    CGFloat currentX = fromPoint.x-currentWidth/2.0;
    CGFloat currentY = arrowDirectionUp?fromPoint.y:(fromPoint.y-currentHeight-_popViewArrowHeight);
    
    // x: 窗口靠左
    if (fromPoint.x <= currentWidth/2 + self.popViewMargin) {
        currentX = self.popViewMargin;
    }
    // x: 窗口靠右
    if (KScreenWidth - fromPoint.x <= currentWidth/2 + self.popViewMargin) {
        currentX = KScreenWidth - self.popViewMargin - currentWidth;
    }
    
    self.frame = CGRectMake(currentX, currentY, currentWidth, currentHeight);
    
    // 截取箭头
    CGPoint arrowPoint = CGPointMake(fromPoint.x - CGRectGetMinX(self.frame), arrowDirectionUp ? 0 : currentHeight); // 箭头顶点在当前视图的坐标
    
    CGFloat maskTop = arrowDirectionUp ? self.popViewArrowHeight : 0; // 顶部Y值
    CGFloat maskBottom = arrowDirectionUp ? currentHeight : currentHeight - self.popViewArrowHeight; // 底部Y值
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    // 左上圆角
    [maskPath moveToPoint:CGPointMake(0, self.contentCornerRadius + maskTop)];
    [maskPath addArcWithCenter:CGPointMake(self.contentCornerRadius, self.contentCornerRadius + maskTop)
                        radius:self.contentCornerRadius
                    startAngle:DegreesToRadians(180)
                      endAngle:DegreesToRadians(270)
                     clockwise:YES];
    if (arrowDirectionUp) {
        // 箭头向上时的箭头位置
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x - self.popViewArrowWidth/2, self.popViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - self.arrowCornerRadius, self.arrowCornerRadius)
                         controlPoint:CGPointMake(arrowPoint.x - self.popViewArrowWidth/2 + self.arrowJoinCornerRadius, self.popViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + self.arrowCornerRadius, self.arrowCornerRadius)
                         controlPoint:arrowPoint];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + self.popViewArrowWidth/2, self.popViewArrowHeight)
                         controlPoint:CGPointMake(arrowPoint.x + self.popViewArrowWidth/2 - self.arrowJoinCornerRadius, self.popViewArrowHeight)];
    }
    // 右上圆角
    [maskPath addLineToPoint:CGPointMake(currentWidth - self.contentCornerRadius, maskTop)];
    [maskPath addArcWithCenter:CGPointMake(currentWidth - self.contentCornerRadius, maskTop + self.contentCornerRadius)
                        radius:self.contentCornerRadius
                    startAngle:DegreesToRadians(270)
                      endAngle:DegreesToRadians(0)
                     clockwise:YES];
    // 右下圆角
    [maskPath addLineToPoint:CGPointMake(currentWidth, maskBottom - self.contentCornerRadius)];
    [maskPath addArcWithCenter:CGPointMake(currentWidth - self.contentCornerRadius, maskBottom - self.contentCornerRadius)
                        radius:self.contentCornerRadius
                    startAngle:DegreesToRadians(0)
                      endAngle:DegreesToRadians(90)
                     clockwise:YES];
    
    if (!arrowDirectionUp) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x + self.popViewArrowWidth/2, currentHeight - self.popViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + self.arrowCornerRadius, currentHeight - self.arrowCornerRadius)
                         controlPoint:CGPointMake(arrowPoint.x + self.popViewArrowWidth/2 - self.arrowJoinCornerRadius, currentHeight - self.popViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - self.arrowCornerRadius, currentHeight - self.arrowCornerRadius)
                         controlPoint:arrowPoint];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - self.popViewArrowWidth/2, currentHeight - self.popViewArrowHeight)
                         controlPoint:CGPointMake(arrowPoint.x - self.popViewArrowWidth/2 + self.arrowJoinCornerRadius, currentHeight - self.popViewArrowHeight)];
    }
    // 左下圆角
    [maskPath addLineToPoint:CGPointMake(self.contentCornerRadius, maskBottom)];
    [maskPath addArcWithCenter:CGPointMake(self.contentCornerRadius, maskBottom - self.contentCornerRadius)
                        radius:self.contentCornerRadius
                    startAngle:DegreesToRadians(90)
                      endAngle:DegreesToRadians(180)
                     clockwise:YES];
    [maskPath addLineToPoint:CGPointMake(0, self.contentCornerRadius + maskTop)];
    
#pragma mark -
    // 截取圆角和箭头
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
#pragma mark - 添加边框
//    UIBezierPath * path = [UIBezierPath bezierPath];
//    path.CGPath = maskPath.CGPath;
    CAShapeLayer * borderLayer = [CAShapeLayer layer];
    borderLayer.lineWidth = 2;
    borderLayer.frame = self.bounds;
    borderLayer.path = maskPath.CGPath;
    borderLayer.strokeColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00].CGColor;
    borderLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:borderLayer];
    [self.overlayWindow addSubview:self.maskView];
    [self.overlayWindow addSubview:self];
    [self.overlayWindow makeKeyAndVisible];
    [self bringSubviewToFront:self.contentView];
    // 弹出动画
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(arrowPoint.x/currentWidth, arrowDirectionUp ? 0.f : 1.f);
    self.frame = oldFrame;
    self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.maskView.alpha = 1.f;
    }];
}

/**隐藏*/
- (void)hide
{
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        self.maskView.alpha = 0.f;
        self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.contentView removeFromSuperview];
        [self removeFromSuperview];
        NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
        [windows removeObject:overlayWindow];
        overlayWindow = nil;
        [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
            if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                [window makeKeyWindow];
                *stop = YES;
            }
        }];
        objc_setAssociatedObject(self, &keyLHDPopView, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:kScreenBounds];
        _maskView.alpha = 0;
        _maskView.backgroundColor = _style==LHDPopViewBackgroundStyleDark?[UIColor colorWithWhite:0.f alpha:0.18f]:[UIColor clearColor];
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
//        [_maskView addGestureRecognizer:tap];
        WeakSelf
        [_maskView addLHDClickedHandle:^(id sender) {
            StrongSelf
            [[strongSelf class] dismiss];
        }];
    }
    return _maskView;
}

/**展示内容的contentView（按自己的需求），弹出大小默认会根据contentView大小，宽度不得超过屏幕宽减20，高度不得超过当前点击点，fromView 箭头指向的View*/
+ (void)showContentView:(UIView *)contentView style:(LHDPopViewBackgroundStyle)style fromView:(UIView *)fromView
{
    LHDPopView * popView = [[LHDPopView alloc] initWithContentView:contentView withStyle:style];
    [popView showFromView:fromView];
    objc_setAssociatedObject(self, &keyLHDPopView, popView, OBJC_ASSOCIATION_ASSIGN);
}

/**展示内容的contentView（按自己的需求），弹出大小默认会根据contentView大小，宽度不得超过屏幕宽减20，高度不得超过当前点击点，fromPoint 箭头指向的Point*/
+ (void)showContentView:(UIView *)contentView style:(LHDPopViewBackgroundStyle)style FromPoint:(CGPoint)fromPoint
{
    LHDPopView * popView = [[LHDPopView alloc] initWithContentView:contentView withStyle:style];
    [popView showFromPoint:fromPoint];
    objc_setAssociatedObject(self, &keyLHDPopView, popView, OBJC_ASSOCIATION_ASSIGN);
}

+ (void)dismiss
{
    dispatch_async(dispatch_get_main_queue(), ^{
        LHDPopView * popView = objc_getAssociatedObject(self, &keyLHDPopView);
        if (popView) {
            [popView hide];
        }
    });
}

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.backgroundColor = [UIColor clearColor];
        overlayWindow.userInteractionEnabled = YES;
    }
    return overlayWindow;
}


static char const keyLHDPopView;

- (void)dealloc
{
    NSLog(@"dealloc:%@",NSStringFromClass([self class]));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

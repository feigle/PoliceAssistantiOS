//
//  DDPullView.h
//  Policeassistant
//
//  Created by DoorDu on 16/7/8.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CPAlignStyle) {
    CPAlignStyleCenter,
    CPAlignStyleLeft,
    CPAlignStyleRight,
};
#define kTriangleHeight 8.0
#define kTriangleWidth 10.0
#define kPopOverLayerCornerRadius 5.0

@class DDPullView;
@protocol DDPopOverViewDelegate <NSObject>

@optional
- (void)popOverViewDidShow:(DDPullView *)pView;
- (void)popOverViewDidDismiss:(DDPullView *)pView;

// for normal use
- (void)popOverView:(DDPullView *)pView didClickMenuIndex:(NSInteger)index;


@end

@interface DDPullView : UIView
@property (nonatomic, strong) NSString  * flagstr;
@property (nonatomic,   weak) id<DDPopOverViewDelegate> delegate;

// you can set custom view or custom viewController
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIViewController *contentViewController;


@property (nonatomic, strong) UIColor *containerBackgroudColor;

+ (instancetype)popOverView;

// for normal use, you can set titles, it will show as a tableview
- (instancetype)initWithBounds:(CGRect)bounds titleMenus:(NSArray *)titles andflagstr:(NSString *)str;


- (void)showFrom:(UIView *)from alignStyle:(CPAlignStyle)style;

- (void)dismiss;

@end

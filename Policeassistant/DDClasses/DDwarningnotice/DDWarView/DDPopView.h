//
//  DDPopView.h
//  tabbar
//
//  Created by DoorDu on 16/6/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDPopView : UIView
@property(nonatomic,strong)UIView *bGView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIImageView *imageView;

@property(copy,nonatomic)void (^ButtonClick)(NSString*);

-(instancetype)initWithTimeText:(NSString *)timelable type:(NSString*)type WithArray:(NSArray*)array;
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
@end

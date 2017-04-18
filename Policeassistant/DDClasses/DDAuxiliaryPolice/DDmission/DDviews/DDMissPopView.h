//
//  DDMissPopView.h
//  Policeassistant
//
//  Created by DoorDu on 16/7/7.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMissPopView : UIView
{
    UIButton *qRButton;
}
@property(nonatomic,strong)UIView *bGView;
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *pachorLabel;
@property(nonatomic,strong)NSString *bgstring;

@property(copy,nonatomic)void (^ButtonClick)(UIButton*,NSString*);

-(instancetype)initWithAlertViewHeight;
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end

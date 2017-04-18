//
//  DDMissPopView.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/7.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDMissPopView.h"
#define WINDOWFirst        [[[UIApplication sharedApplication] windows] firstObject]
@implementation DDMissPopView

-(instancetype)initWithAlertViewHeight
{
    self=[super init];
    if (self) {
        if (self.bGView==nil) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.5;
            [WINDOWFirst addSubview:view];
            self.bGView =view;
        }
        
        self.center = CGPointMake(KScreenWidth/2, KScreenHeight/2-64);
        self.bounds = CGRectMake(0, 0, KScreenWidth*0.8-30, KScreenWidth*0.8-30);
        self.backgroundColor=[UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        [WINDOWFirst addSubview:self];
        
        
        UILabel *lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(0, 10, KScreenWidth*0.8-30, 20);
        lab.text = @"任务完成描述";
        lab.font = [UIFont systemFontOfSize:18];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = MAINTEX;
        [self addSubview:lab];
        self.titleLabel =lab;
        
        
        self.textView=[[UITextView alloc]init];
        [self setupOneTextView:self.textView WithFrame:CGRectMake(15, CGRectGetMaxY(lab.frame)+10, KScreenWidth*0.8-60, KScreenWidth*0.8-140) string:@""];
        [self addSubview:self.textView];
        
        _pachorLabel= [[UILabel alloc]initWithFrame:CGRectMake(5, 8, KScreenWidth*0.8-60, 20)];
        _pachorLabel.enabled = NO;
        _pachorLabel.text = @"输入内容不得少于10个字";
        _pachorLabel.numberOfLines=0;
        _pachorLabel.font =  [UIFont systemFontOfSize:16];
        _pachorLabel.textColor = [UIColor lightGrayColor];
        self.textView.returnKeyType=UIReturnKeyDone;
        [self.textView addSubview:_pachorLabel];
        
        
        CGFloat btnWidth = (KScreenWidth*0.8-75)/2;
        CGFloat btnHeight = 40;
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.frame = CGRectMake(15, CGRectGetMaxY(self.textView.frame)+15, btnWidth, btnHeight);
        [cancelButton setTitle:@"取消" forState:0];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        cancelButton.tag =1000;
        cancelButton.layer.masksToBounds = YES;
        cancelButton.layer.cornerRadius = 5;
        cancelButton.layer.borderWidth = 1;
        cancelButton.layer.borderColor = [DaohangCOLOR CGColor];
        [cancelButton setTitleColor:DaohangCOLOR forState:0];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"box"] forState:0];
        [cancelButton addTarget:self action:@selector(buttonClickone:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:cancelButton];
        
        qRButton = [UIButton buttonWithType:UIButtonTypeSystem];
        qRButton.frame = CGRectMake(cancelButton.frame.origin.x+cancelButton.frame.size.width+15, cancelButton.frame.origin.y, btnWidth, btnHeight);
        [qRButton setTitle:@"确定" forState:0];
        [qRButton setTitleColor:[UIColor whiteColor] forState:0];
        qRButton.titleLabel.font = cancelButton.titleLabel.font;
        qRButton.layer.masksToBounds = YES;
        qRButton.layer.cornerRadius = 5;
        qRButton.tag=1001;
        [qRButton setTitleColor:[UIColor whiteColor] forState:0];
        [qRButton setBackgroundColor:DaohangCOLOR];
        [qRButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:qRButton];
        [self show:YES];
        
    }
    return self;
}
#pragma ------- 监听输入信息，隐藏水印提示 ------
- (void) textViewDidChange:(UITextView *)textView{
    
    if ([textView.text length] == 0) {
        [_pachorLabel setHidden:NO];
    }else{
        [_pachorLabel setHidden:YES];
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}

-(void)buttonClick:(UIButton*)button
{
    if ([self.textView.text length]<10||[DDTools isEmpty:self.textView.text]) {
        [DDProgressHUD showCenterWithText:@"少于10个字！" duration:1.0];
    }else if ([self.textView.text length]>100){
        [DDProgressHUD showCenterWithText:@"最多输入100个字！" duration:1.0];
    }
    else{
    [self hide:YES];
    if (self.ButtonClick) {
        _bgstring=self.textView.text;
        self.ButtonClick(button,_bgstring);
    }
    }
}
-(void)buttonClickone:(UIButton*)button{
    [self hide:YES];
}
- (void)show:(BOOL)animated
{
    if (animated)
    {
        self.transform = CGAffineTransformScale(self.transform,0,0);
        __weak DDMissPopView *weakSelf = self;
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 animations:^{
                weakSelf.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)hide:(BOOL)animated
{
    [self endEditing:YES];
    if (self.bGView != nil) {
        __weak DDMissPopView *weakSelf = self;
        
        [UIView animateWithDuration:animated ?0.3: 0 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1,1);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration: animated ?0.3: 0 animations:^{
                weakSelf.transform = CGAffineTransformScale(weakSelf.transform,0.2,0.2);
            } completion:^(BOOL finished) {
                [weakSelf.bGView removeFromSuperview];
                [weakSelf removeFromSuperview];
                weakSelf.bGView=nil;
            }];
        }];
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat liuHeight = KScreenHeight-(self.frame.origin.y+self.frame.size.height);
    if (liuHeight<216) {
        CGRect rect = self.frame;
        rect.origin.y = rect.origin.y-(216-liuHeight);
        self.frame =rect;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.center = self.superview.center;
    [self endEditing:YES];
    
    return YES;
}
- (void)setupOneTextView:(UITextView *)textview WithFrame :(CGRect)frame string:(NSString *)string{
    textview.frame=frame;
    textview.backgroundColor=[UIColor whiteColor]; //背景色
    textview.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    textview.editable = YES;        //是否允许编辑内容，默认为“YES”
    
    textview.delegate = (id<UITextViewDelegate>)self;       //设置代理方法的实现类
    textview.font=[UIFont fontWithName:@"Arial" size:16.0]; //设置字体名字和字体大小;
    textview.returnKeyType = UIReturnKeyDefault;//return键的类型
    textview.layer.borderWidth = 1;
    //倒角
    textview.layer.cornerRadius = 0;
    textview.layer.borderColor = [LINECOLOR CGColor];
    textview.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    textview.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    
    textview.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
    
    textview.textColor = MAINTEX;
    
    textview.text = [NSString stringWithFormat:@"%@",string];//设置显示的文本内容
}


@end

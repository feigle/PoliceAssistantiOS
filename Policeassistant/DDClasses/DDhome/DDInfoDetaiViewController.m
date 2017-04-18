//
//  DDInfoDetaiViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/29.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDInfoDetaiViewController.h"

@interface DDInfoDetaiViewController ()<UITextViewDelegate>
{
    UILabel *firstlab;
    UILabel *secendlab;
    UILabel *timelab;
}
@property (nonatomic,strong) UITextView * textView;
@property (nonatomic,strong)NSDictionary *datadic;

@end

@implementation DDInfoDetaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"信息公告";
    NSLog(@"===%@",_datadic);
    firstlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth-20, 45)];
    firstlab.textColor=[UIColor blackColor];
    firstlab.font=[UIFont systemFontOfSize:18];
    firstlab.numberOfLines=0;
    firstlab.text=[NSString stringWithFormat:@"%@",_datadic[@"dep_name"]];
    [self.view addSubview:firstlab];
    
    secendlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 45, KScreenWidth-20, 40)];
    secendlab.textColor=[UIColor blackColor];
    secendlab.font=[UIFont systemFontOfSize:15];
    secendlab.numberOfLines=0;
    secendlab.text=[NSString stringWithFormat:@"%@",_datadic[@"title"]];
    [self.view addSubview:secendlab];
    
    timelab=[[UILabel alloc]initWithFrame:CGRectMake(10, 80, KScreenWidth-20, 20)];
    timelab.textColor=TEXCOLOR;
    timelab.font=[UIFont systemFontOfSize:15];
    timelab.text=[NSString stringWithFormat:@"%@",_datadic[@"time"]];
    [self.view addSubview:timelab];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 99, KScreenWidth, 0.5)];
    line.backgroundColor=LINECOLOR;
    [self.view addSubview:line];
    self.textView=[[UITextView alloc] initWithFrame:CGRectMake(10, 100, KScreenWidth-20, KScreenHeight-100)]; //初始化大小并自动释放
    
    self.textView.textColor
    = TEXCOLOR;//设置textview里面的字体颜色
    
    self.textView.font
    = [UIFont fontWithName:@"Arial"size:16.0];//设置字体名字和字体大小
    
    self.textView.delegate
    = self;//设置它的委托方法
    
    self.textView.backgroundColor
    = TableViewBg;//设置它的背景颜色
    
    self.textView.text
    =[NSString stringWithFormat:@"%@",_datadic[@"content"]];//设置它显示的内容
    
    self.textView.returnKeyType
    = UIReturnKeyDefault;//返回键的类型
    
    self.textView.keyboardType
    = UIKeyboardTypeDefault;//键盘类型
    
    self.textView.scrollEnabled
    = YES;//是否可以拖动
    
    self.textView.editable
    =NO;//禁止编辑
    
    self.textView.autoresizingMask
    = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    [self.view
     addSubview: self.textView];//加入到整个页面中
}


@end

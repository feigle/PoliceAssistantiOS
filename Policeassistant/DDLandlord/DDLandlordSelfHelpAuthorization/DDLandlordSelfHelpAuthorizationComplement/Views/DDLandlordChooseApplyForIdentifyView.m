//
//  DDLandlordChooseApplyForIdentify.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/13.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordChooseApplyForIdentifyView.h"

@interface DDLandlordChooseApplyForIdentifyView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic,strong) NSArray * dataArray;
@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) UIView * pickerContentView;
/** 6.选择器 */
@property (nonatomic, strong, nullable)UIPickerView *pickerView;
@property (nonatomic,strong) DDLandlordChooseApplyForIdentifyReturnDataBlock returnDataBlock;
/**选中了第几个*/
@property (nonatomic,assign) NSInteger selectedRow;

@end

@implementation DDLandlordChooseApplyForIdentifyView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithDataArray:(NSArray *)dataArray
{
    self = [super init];
    if (self) {
        _dataArray = dataArray;
        [self configUI];
    }
    return self;
}

#pragma mark - 完成点击事件
- (void)doneBtnClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
        {
            [self dismiss];
        }
            break;
        case 101:
        {
            if (self.returnDataBlock) {
                self.returnDataBlock(self.selectedRow);
            }
            [self dismiss];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIPickerViewDataSource  && UIPickerViewDelegate 的代理事件

#pragma mark --- UIPickerViewDataSource代理方法
//设置列的返回数量
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//设置列里边组件的个数 component:组件
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}
#pragma mark --- UIPickerViewDelegate代理方法
//返回组件的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataArray[row];
}
//选择器选择的方法  row：被选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedRow = row;
}


- (void)configUI
{
    self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self addSubview:self.bgView];
    [self addSubview:self.pickerContentView];
    [self configTopView];
}


- (void)configTopView
{
    UIView * choseBgView = [self topView];
    self.pickerContentView.userInteractionEnabled = YES;
    [self.pickerContentView addSubview:choseBgView];
    
    [self.pickerContentView addSubview:self.pickerView];
    self.pickerView.top = choseBgView.bottom;
    self.pickerContentView.height = self.pickerView.bottom;
}


- (UIView *)topView
{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    NSArray * btnTitleArray = @[@"取消", @"完成"];
    for (NSInteger i = 0; i < btnTitleArray.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(i*(KScreenWidth-66), 0, 66, 30);
        [btn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+100;
        btn.titleLabel.font = font6Size(28/2.0);
        btn.centerY = bgView.height/2.0;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:[btnTitleArray objectAtIndex:i] forState:UIControlStateNormal];
        [bgView addSubview:btn];
    }
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.height-0.5, KScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.00];
    [bgView addSubview:lineView];
    return bgView;
}

/** 6.选择器 */
- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0  , KScreenWidth, 240)];
        [_pickerView setBackgroundColor:[UIColor whiteColor]];
        [_pickerView setDataSource:self];
        [_pickerView setDelegate:self];
    }
    return _pickerView;
}
/**
 内容view
 */
- (UIView *)pickerContentView
{
    if (!_pickerContentView) {
        _pickerContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
        _pickerContentView.userInteractionEnabled = YES;
        _pickerContentView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerContentView;
}

/**
 背景view
 */
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _bgView.userInteractionEnabled = YES;
        _bgView.alpha = 0;
        _bgView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}


- (void)getIdentifyDataBlock:(DDLandlordChooseApplyForIdentifyReturnDataBlock)block
{
    self.returnDataBlock = block;
}

- (void)show
{
    UIWindow *window = [self getNowWindow];
    [window addSubview:self];
    WeakSelf
    self.pickerContentView.top = self.height;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        StrongSelf
        strongSelf.pickerContentView.top = strongSelf.height-strongSelf.pickerContentView.height;
        strongSelf.bgView.alpha = 0.5;
    } completion:^(BOOL finished) {
    }];
}
- (void)dismiss
{
    WeakSelf
    [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        StrongSelf
        strongSelf.pickerContentView.top = strongSelf.height;
        strongSelf.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        StrongSelf
        [strongSelf.pickerView removeFromSuperview];
        strongSelf.pickerView.delegate = nil;
        strongSelf.pickerView.dataSource = nil;
        [strongSelf removeFromSuperview];
    }];
}
- (UIWindow *)getNowWindow
{
    UIWindow * nowWindow  = [[UIApplication sharedApplication].delegate window];
    return nowWindow;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

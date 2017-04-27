//
//  CusstomDatePickerView.m
//  GreatHappiness
//
//  Created by 秦沙沙 on 16/5/31.
//  Copyright © 2016年 深圳脸熟科技有限公司. All rights reserved.
//

#import "CusstomDatePickerView.h"

@interface CusstomDatePickerView ()
{
    CusstomDatePickerBackType datePickerBackType;
}

@property (nonatomic, strong, readonly) UIWindow *overlayWindow;

@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) UIView * pickerContentView;
@property (nonatomic,strong) UIDatePicker * datePicker;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,copy) GetCusstomDatePickerViewBlock  pickerBlock;
@property (nonatomic,copy) GetCusstomDatePickerViewBlock  doneBlock;
@property (nonatomic,copy) CancelCusstomDatePickerViewBlock  canelBlock;

@end

@implementation CusstomDatePickerView
@synthesize overlayWindow;


- (instancetype)initWithDatePickerMode:(UIDatePickerMode)datePickerMode timeBackType:(CusstomDatePickerBackType)timeBackType maximumDate:(NSDate *)maximumDate minimumDate:(NSDate *)minimumDate defaultDate:(NSDate *)defaultDate title:(NSString *)title
{
    self = [super initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    if (self) {
        //注册登录状态监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loginStateChange:)
                                                     name:KNOTIFICATION_LOGINCHANGE
                                                   object:nil];
        [self configUIDatePickerMode:datePickerMode timeBackType:timeBackType maximumDate:maximumDate minimumDate:minimumDate defaultDate:defaultDate title:title];
    }
    return self;
}

- (void)loginStateChange:(NSNotification *)notification
{
    /**[1=>'管理员',2=>'民警',3=>'协警',4=>'保安',5=>'物业',6=>'房东'];*/
    /**登录身份*/
    PoliceAssistantIdentityType identityType = [notification.object integerValue];
    switch (identityType) {
        case PoliceAssistantNoLoginType://没有登录
        {
            [self dismiss];
        }
            break;
        default:
            break;
    }
}


/**
    初始化界面
 */
- (void)configUIDatePickerMode:(UIDatePickerMode)datePickerMode timeBackType:(CusstomDatePickerBackType)timeBackType maximumDate:(NSDate *)maximumDate minimumDate:(NSDate *)minimumDate defaultDate:(NSDate *)defaultDate title:(NSString *)title
{
    datePickerBackType = timeBackType;
    [self addSubview:self.bgView];
    [self addSubview:self.pickerContentView];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 216)];
    _datePicker.datePickerMode = datePickerMode;
    _datePicker.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00];
    if (maximumDate) {
        _datePicker.maximumDate = maximumDate;
    }
    if (minimumDate) {
        _datePicker.minimumDate = minimumDate;
    }
    if (defaultDate) {
        _datePicker.date = defaultDate;
    } else {
        _datePicker.date = [NSDate date];
    }
    self.titleLabel.text = [title toString];
    [self configTopView];
}

- (void)configTopView
{
    UIView * choseBgView = [self topView];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.pickerContentView addSubview:choseBgView];
    [self.pickerContentView addSubview:_datePicker];
    _datePicker.top = choseBgView.bottom;
    self.pickerContentView.height = _datePicker.bottom;
}
#pragma mark - 当滑动的时候
- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    [self returnSelectedDate:YES];
}

- (UIView *)topView
{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00];
    [bgView addSubview:self.titleLabel];
    NSArray * btnTitleArray = @[@"取消", @"确定"];
    for (NSInteger i = 0; i < btnTitleArray.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(i*(KScreenWidth-66), 0, 66, 40);
        [btn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+100;
        btn.titleLabel.font = font6Size(34/2.0);
        [btn setTitleColor:[UIColor colorWithRed:0.00 green:0.45 blue:0.98 alpha:1.00] forState:UIControlStateNormal];
        [btn setTitle:[btnTitleArray objectAtIndex:i] forState:UIControlStateNormal];
        [bgView addSubview:btn];
    }
    UIView * LineView = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.height-0.5, KScreenWidth, 0.5)];
    LineView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.00];
    [bgView addSubview:LineView];
    return bgView;
}

- (void)doneBtnClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 100://取消
        {
            [self dismiss];
        }
            break;
        case 101://确定
        {
            [self returnSelectedDate:NO];
        }
            break;
            
        default:
            break;
    }
}

- (void)returnSelectedDate:(BOOL)isConstantly
{
    NSDate *selectedDate = [_datePicker date];
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
//    dateFormatter.timeZone = sourceTimeZone;
    
    switch (datePickerBackType) {
        case NianYueRiState://@"yyyy-MM-dd"用于选择生日
        {
            [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        }
            break;
        case DetailTimeState://@"yyyy-MM-dd HH:mm" 选择日期
        {
            [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
        }
            break;
        case CNianYueRiState://@"yyyy年MM月dd日"用于选择生日
        {
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        }
            break;
        case CDetailTimeState://@"yyyy年MM日dd日 HH:mm" 选择日期
        {
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        }
            break;
            
        default:
            break;
    }
    NSString *destDateString = [dateFormatter stringFromDate:selectedDate];
    
//    NSTimeZone *timeZone=[NSTimeZone systemTimeZone];
//    NSInteger seconds=[timeZone secondsFromGMTForDate:selectedDate];
//    NSDate *newDate=[selectedDate dateByAddingTimeInterval:seconds];
//    
//    NSString *newTimeStr=[dateFormatter stringFromDate:newDate];
//    NSLog(@"newDate----%@",newDate);
//    NSLog(@"newTimeStr-------%@",newTimeStr);
    
    if (isConstantly) {
        if (self.pickerBlock) {
            self.pickerBlock(self,destDateString,selectedDate);
        }
    } else {
        if (self.doneBlock) {
            if (selectedDate) {
                self.doneBlock(self,destDateString,selectedDate);
            }else{
                self.doneBlock(self,[dateFormatter stringFromDate:[NSDate date]],[NSDate date]);
            }
        }
        [self dismiss];
    }
}
- (void)getCusstomDatePickerViewWithBlock:(GetCusstomDatePickerViewBlock)block doneBlock:(GetCusstomDatePickerViewBlock)doneBlock cancelBlock:(CancelCusstomDatePickerViewBlock)cancelBlock
{
    self.pickerBlock = block;
    self.doneBlock = doneBlock;
    self.canelBlock = cancelBlock;
}

/**
    内容view
 */
- (UIView *)pickerContentView
{
    if (!_pickerContentView) {
        _pickerContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
        _pickerContentView.userInteractionEnabled = YES;
        _pickerContentView.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00];
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
/**
    用于显示标题
 */
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = font6Size(34/2.0);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)show
{
    [self.overlayWindow addSubview:self];
    [self.overlayWindow makeKeyAndVisible];
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
    if (self.canelBlock) {
        self.canelBlock();
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_LOGINCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    WeakSelf
    [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        StrongSelf
        strongSelf.pickerContentView.top = strongSelf.height;
        strongSelf.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        StrongSelf
        if (strongSelf.bgView.alpha == 0) {
            [strongSelf removeFromSuperview];
            NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
            [windows removeObject:overlayWindow];
            overlayWindow = nil;
            [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                    [window makeKeyWindow];
                    *stop = YES;
                }
            }];
        }
    }];
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

- (void)dealloc
{
    NSLog(@"dealloc: %@",NSStringFromClass([self class]));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

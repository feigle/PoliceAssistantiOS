//
//  CusstomDatePickerView.h
//  GreatHappiness
//
//  Created by 秦沙沙 on 16/5/31.
//  Copyright © 2016年 深圳脸熟科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NianYueRiState,  //@"yyyy.MM.dd"用于选择生日
    DetailTimeState,  //@"yyyy.MM.dd HH:mm" 选择日期
    CNianYueRiState,  //@"yyyy年MM月dd日"用于选择生日
    CDetailTimeState,  //@"yyyy年MM日dd日 HH:mm" 选择日期
} CusstomDatePickerBackType;//返回时间字符串类型

@class CusstomDatePickerView;

/**
    @dateString
               根据CusstomDatePickerBackType返回对应的格式
    @selectedDate
               返回NSDate时间
 */
typedef void (^GetCusstomDatePickerViewBlock)(CusstomDatePickerView * pickerView,NSString * dateString,NSDate * selectedDate);
typedef void (^CancelCusstomDatePickerViewBlock)();
@interface CusstomDatePickerView : UIView
/**
 时间类型选择器
 @ datePickerMode
             UIDatePickerModeTime用户选择当天的时间
             UIDatePickerModeDate用于选择生日用的
             UIDatePickerModeDateAndTime用于选择今年的日期和时间
             UIDatePickerModeCountDownTimer 用于选择当个小时和分钟
 @timeBackType 
             时间返回的格式
 @maximumDate
            最大的时间，可以为nil(用于选择生日的时候，肯定不能超过当前的时间)（[NSDate date]）,活动的开始时间也肯定大于当前的时间
 @minimumDate
            最小的时间，可以为nil（用于选择活动时间的时候，设置结束时间的时候（最小时间应该为开始时间）
 @defaultDate
            默认弹出后，显示的时间，默认为当前的时间
 */
- (instancetype)initWithDatePickerMode:(UIDatePickerMode)datePickerMode timeBackType:(CusstomDatePickerBackType)timeBackType maximumDate:(NSDate *)maximumDate minimumDate:(NSDate *)minimumDate defaultDate:(NSDate *)defaultDate title:(NSString *)title;
/**
    返回获取的时间
    @block 这里时时获取改变后的时间
    @doneBlock 点击确定按钮后获取时间
    @cancelBlock 取消事件
 */
- (void)getCusstomDatePickerViewWithBlock:(GetCusstomDatePickerViewBlock)block doneBlock:(GetCusstomDatePickerViewBlock)doneBlock cancelBlock:(CancelCusstomDatePickerViewBlock)cancelBlock;
- (void)show;
- (void)dismiss;

@end

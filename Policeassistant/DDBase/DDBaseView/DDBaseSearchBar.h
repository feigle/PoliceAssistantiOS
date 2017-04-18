//
//  DDBaseSearchBar.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/8.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDBaseView.h"

@interface DDBaseSearchBar : DDBaseView

@property (nonatomic, strong,nullable) UISearchBar * searchBar;

@property (nonatomic, strong,nullable) UITextField *searchField;
@property (nonatomic, strong,nullable) UIColor * placeholderColor;//搜索框placeholder的字体颜色
@property (nonatomic, strong,nullable) UIFont *  placeholderFont;//搜索框placeholder的字体Font
@property (nonatomic, strong,nullable) UIColor * textFieldBgColor;//搜索框的背景颜色
@property (nonatomic, strong,nullable) UIColor * bgColor;//背景颜色
@property (nonatomic,copy,nullable)   NSString  *text;
@property (nonatomic, copy,nullable) id delegate;
@property (nonatomic, strong,nullable) NSString * placeholder;

- (void)setShowsCancelButton:(BOOL)showsCancelButton animated:(BOOL)animated;
/**
 *  自定义控件自带的取消按钮的文字（默认为“取消”/“Cancel”）
 *
 *  @param title 自定义文字
 */
//- (void)setCancelButtonTitle:(NSString *)title;
- (BOOL)isFirstResponder;
- (BOOL)resignFirstResponder;
- (BOOL)becomeFirstResponder;


@end

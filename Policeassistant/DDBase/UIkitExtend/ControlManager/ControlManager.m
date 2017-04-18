//
//  ControlManager.m
//  刘和东
//
//  Created by 秦沙沙 on 2014/12/28.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import "ControlManager.h"

@implementation ControlManager

+ (UIView *)viewWithFrame:(CGRect)frame
{
    UIView * view = [[UIView alloc] initWithFrame:frame];
    return view;
}
/**得到UIView控件*/
+ (UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor
{
    UIView * view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor  = backgroundColor;
    return view;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame buttonType:(UIButtonType)buttonType objc:(id)objc sel:(SEL)sel
{
    UIButton * btn = [UIButton buttonWithType:buttonType];
    btn.frame = frame;
    if (objc && sel) {
        [btn addTarget:objc action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}
/**高亮的button*/
+ (UIButton*)buttonNormalImage:(NSString*)imageName hightLightImage:(NSString*)hightImage frame:(CGRect)frame target:(id)target selector:(SEL)selector
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    imageName ? [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal] : nil;
    
    hightImage ? [btn setImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted] : nil;
    
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
/**选中的button*/
+ (UIButton*)buttonNormalImage:(NSString*)imageName selectImageName:(NSString*)selectImageName frame:(CGRect)frame target:(id)target selector:(SEL)selector
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    imageName ?  [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal] : nil;
    selectImageName ? [btn setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected] : nil;
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

/**button*/
+ (UIButton *)buttonBackgroundImage:(NSString *)imageName  hightLightImage:(NSString*)hightImage  title:(NSString *)title frame:(CGRect)frame target:(id)target selector:(SEL)selector
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    imageName ? [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal] : nil;
    hightImage ? [btn setBackgroundImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted] : nil;
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


+ (UIButton *)buttonBackgroundImage:(NSString *)imageName title:(NSString *)title frame:(CGRect)frame target:(id)target selector:(SEL)selector
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    imageName ? [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal] : nil;
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

/**button*/
+ (UIButton *)buttonTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor frame:(CGRect)frame target:(id)target selector:(SEL)selector
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    return btn;
}
/**button*/
+ (UIButton *)buttonTitle:(NSString *)title frame:(CGRect)frame target:(id)target selector:(SEL)selector
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


+ (UIImageView *)imageView
{
    UIImageView * imageView = [[UIImageView alloc] init];
    return imageView;
}

/**得到UIImageView控件*/
+ (UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.autoresizingMask = UIViewAutoresizingNone;
    if (imageName) {
        UIImage * image = [UIImage imageNamed:imageName];
        imageView.image = image;
    }
    return imageView;
}

/**得到UIImageView控件*/
+ (UIImageView *)imageViewWithImageName:(NSString *)imageName
{
    if (!imageName) {
        return [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
}
/**得到UIImageView控件*/
+ (UIImageView *)imageViewWithImage:(UIImage *)image
{
    if (!image) {
        return [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return [[UIImageView alloc] initWithImage:image];
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.autoresizingMask = UIViewAutoresizingNone;
    return imageView;
}

/**得到UILabel控件*/
+ (UILabel*)lableFrame:(CGRect)frame title:(NSString *)title font:(UIFont*)font textColor:(UIColor*)textColor
{
    UILabel *lable=[[UILabel alloc]initWithFrame:frame];
    lable.text=title;
    lable.font=font;
    lable.lineBreakMode=NSLineBreakByWordWrapping;
    lable.textColor=textColor;
    return lable;
}
/**得到UILabel控件*/
+ (UILabel*)lableFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor
{
    UILabel *lable=[[UILabel alloc]initWithFrame:frame];
    lable.font=font;
    lable.lineBreakMode=NSLineBreakByWordWrapping;
    lable.textColor=textColor;
    return lable;
}
/**得到UILabel控件*/
+ (UILabel*)lableFrame:(CGRect)frame title:(NSString *)title font:(UIFont*)font textColor:(UIColor*)textColor textAligment:(NSTextAlignment)aligment
{
    UILabel *lable=[[UILabel alloc]initWithFrame:frame];
    lable.text=title;
    lable.font=font;
    lable.lineBreakMode=NSLineBreakByWordWrapping;
    lable.textColor=textColor;
    lable.textAlignment = aligment;
    return lable;
}
/**得到UILabel控件*/
+ (UILabel*)lableFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor textAligment:(NSTextAlignment)aligment
{
    UILabel *lable=[[UILabel alloc]initWithFrame:frame];
    lable.font=font;
    lable.lineBreakMode=NSLineBreakByWordWrapping;
    lable.textColor=textColor;
    lable.textAlignment = aligment;
    return lable;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont*)font textColor:(UIColor*)textColor  textAligment:(NSTextAlignment)aligment placeholder:(NSString *)placeholder
{
    UITextField * textField = [[UITextField alloc] initWithFrame:frame];
    textField.text = text;
    textField.font = font;
    textField.textColor = textColor;
    textField.textAlignment = aligment;
    textField.placeholder = placeholder;
    return textField;
}

/**得到UITextField控件*/
+ (UITextField *)textFieldWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont*)font textColor:(UIColor*)textColor  textAligment:(NSTextAlignment)aligment
{
    UITextField * textField = [[UITextField alloc] initWithFrame:frame];
    textField.text = text;
    textField.font = font;
    textField.textColor = textColor;
    textField.textAlignment = aligment;
    return textField;
}
/**text、font、textColor、placeholder得到UITextField控件*/
+ (UITextField *)textFieldWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont*)font textColor:(UIColor*)textColor placeholder:(NSString *)placeholder
{
    UITextField * textField = [[UITextField alloc] initWithFrame:frame];
    textField.text = text;
    textField.font = font;
    textField.textColor = textColor;
    textField.placeholder = placeholder;
    return textField;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor  textAligment:(NSTextAlignment)aligment placeholder:(NSString *)placeholder
{
    UITextField * textField = [[UITextField alloc] initWithFrame:frame];
    textField.font = font;
    textField.textColor = textColor;
    textField.textAlignment = aligment;
    textField.placeholder = placeholder;
    return textField;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor placeholder:(NSString *)placeholder
{
    UITextField * textField = [[UITextField alloc] initWithFrame:frame];
    textField.font = font;
    textField.textColor = textColor;
    textField.placeholder = placeholder;
    return textField;
}

/**font、textColor、textAligment得到UITextField控件*/
+ (UITextField *)textFieldWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor
{
    UITextField * textField = [[UITextField alloc] initWithFrame:frame];
    textField.font = font;
    textField.textColor = textColor;
    return textField;
}
/**得到UITextField控件*/
+ (UITextField *)textFieldWithFrame:(CGRect)frame
{
    UITextField * textField = [[UITextField alloc] initWithFrame:frame];
    return textField;
}

/**
 *  得到UIScrollView控件
 */
+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame isBounces:(BOOL)isBounces isShowVerticalScrollIndicator:(BOOL)isShowVerticalScrollIndicator isShowHorizontalScrollIndicator:(BOOL)isShowHorizontalScrollIndicator
{
    UIScrollView * ScrollView = [[UIScrollView alloc] initWithFrame:frame];
    ScrollView.bounces = isBounces;
    ScrollView.showsHorizontalScrollIndicator = isShowHorizontalScrollIndicator;
    ScrollView.showsVerticalScrollIndicator = isShowVerticalScrollIndicator;
    ScrollView.scrollsToTop = NO;
    return ScrollView;
}

/**得到UIScrollView控件*/
+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame isBounces:(BOOL)isBounces isShowIndicator:(BOOL)isShowIndicator
{
    UIScrollView * ScrollView = [[UIScrollView alloc] initWithFrame:frame];
    ScrollView.bounces = isBounces;
    ScrollView.showsHorizontalScrollIndicator = isShowIndicator;
    ScrollView.showsVerticalScrollIndicator = isShowIndicator;
    ScrollView.scrollsToTop = NO;
    return ScrollView;
}
/**得到UIScrollView控件*/
+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame isShowIndicator:(BOOL)isShowIndicator
{
    UIScrollView * ScrollView = [[UIScrollView alloc] initWithFrame:frame];
    ScrollView.showsHorizontalScrollIndicator = isShowIndicator;
    ScrollView.showsVerticalScrollIndicator = isShowIndicator;
    ScrollView.scrollsToTop = NO;
    return ScrollView;
}

/**得到UITableView控件*/
+ (UITableView *)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style dataSourceDelegate:(id)objc
{
    UITableView *  tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.delegate = objc;
    tableView.dataSource = objc;
    tableView.tableFooterView = [[UIView alloc] init];
    return tableView;
}

@end

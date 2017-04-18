//
//  ControlManager.h
//  刘和东
//
//  Created by 秦沙沙 on 2014/12/28.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlManager : NSObject

/**得到UIView控件*/
+ (UIView *)viewWithFrame:(CGRect)frame;
/**得到UIView控件*/
+ (UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor;

/**得到UIButton控件*/
+ (UIButton *)buttonWithFrame:(CGRect)frame buttonType:(UIButtonType)buttonType objc:(id)objc sel:(SEL)sel;
/**高亮的button*/
+ (UIButton*)buttonNormalImage:(NSString*)imageName hightLightImage:(NSString*)hightImage frame:(CGRect)frame target:(id)target selector:(SEL)selector;
/**选中的button*/
+ (UIButton*)buttonNormalImage:(NSString*)imageName selectImageName:(NSString*)selectImageName frame:(CGRect)frame target:(id)target selector:(SEL)selector;
/**button*/
+ (UIButton *)buttonBackgroundImage:(NSString *)imageName title:(NSString *)title frame:(CGRect)frame target:(id)target selector:(SEL)selector;
/**button*/
+ (UIButton *)buttonBackgroundImage:(NSString *)imageName  hightLightImage:(NSString*)hightImage  title:(NSString *)title frame:(CGRect)frame target:(id)target selector:(SEL)selector;

/**button*/
+ (UIButton *)buttonTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor frame:(CGRect)frame target:(id)target selector:(SEL)selector;
/**button*/
+ (UIButton *)buttonTitle:(NSString *)title frame:(CGRect)frame target:(id)target selector:(SEL)selector;

/**得到UIImageView控件*/
+ (UIImageView *)imageView;
/**imageName得到UIImageView控件*/
+ (UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;
/**得到UIImageView控件*/
+ (UIImageView *)imageViewWithImageName:(NSString *)imageName;
/**image得到UIImageView控件*/
+ (UIImageView *)imageViewWithImage:(UIImage *)image;
/**imageName得到UIImageView控件*/
+ (UIImageView *)imageViewWithFrame:(CGRect)frame;

/**title、font、textColor得到UILabel控件*/
+ (UILabel*)lableFrame:(CGRect)frame title:(NSString *)title font:(UIFont*)font textColor:(UIColor*)textColor;
/**font、textColor得到UILabel控件*/
+ (UILabel*)lableFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor;
/**title、font、textColor、textAligment得到UILabel控件*/
+ (UILabel*)lableFrame:(CGRect)frame title:(NSString *)title font:(UIFont*)font textColor:(UIColor*)textColor textAligment:(NSTextAlignment)aligment;
/**font、textColor、textAligment得到UILabel控件*/
+ (UILabel*)lableFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor textAligment:(NSTextAlignment)aligment;

/**text、font、textColor、textAligment、placeholder得到UITextField控件*/
+ (UITextField *)textFieldWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont*)font textColor:(UIColor*)textColor  textAligment:(NSTextAlignment)aligment placeholder:(NSString *)placeholder;
/**text、font、textColor、textAligment得到UITextField控件*/
+ (UITextField *)textFieldWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont*)font textColor:(UIColor*)textColor  textAligment:(NSTextAlignment)aligment;
/**text、font、textColor、placeholder得到UITextField控件*/
+ (UITextField *)textFieldWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont*)font textColor:(UIColor*)textColor placeholder:(NSString *)placeholder;
/**font、textColor、textAligment、placeholder得到UITextField控件*/
+ (UITextField *)textFieldWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor  textAligment:(NSTextAlignment)aligment placeholder:(NSString *)placeholder;
/**font、textColor、placeholder得到UITextField控件*/
+ (UITextField *)textFieldWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor placeholder:(NSString *)placeholder;
/**font、textColor、textAligment得到UITextField控件*/
+ (UITextField *)textFieldWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor;
/**得到UITextField控件*/
+ (UITextField *)textFieldWithFrame:(CGRect)frame;

/**得到UIScrollView控件*/
+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame isBounces:(BOOL)isBounces isShowVerticalScrollIndicator:(BOOL)isShowVerticalScrollIndicator isShowHorizontalScrollIndicator:(BOOL)isShowHorizontalScrollIndicator;
/**得到UIScrollView控件*/
+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame isBounces:(BOOL)isBounces isShowIndicator:(BOOL)isShowIndicator;
/**得到UIScrollView控件*/
+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame isShowIndicator:(BOOL)isShowIndicator;

/**得到UITableView控件*/
+ (UITableView *)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style dataSourceDelegate:(id)objc;


@end

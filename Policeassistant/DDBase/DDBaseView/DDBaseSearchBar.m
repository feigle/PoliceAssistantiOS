//
//  DDBaseSearchBar.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/8.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDBaseSearchBar.h"

@interface DDBaseSearchBar ()

@end


@implementation DDBaseSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.searchBar];
    }
    return self;
}
/**
 
 */

//placeholderColor;//搜索框placeholder的字体颜色
//placeholderFont;//搜索框placeholder的字体Font
//textFieldBgColor;//搜索框的背景颜色
//bgColor;//背景颜色

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    [_searchField setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont
{
    _placeholderFont = placeholderFont;
    [_searchField setValue:placeholderFont forKeyPath:@"_placeholderLabel.font"];
}

- (void)setTextFieldBgColor:(UIColor *)textFieldBgColor
{
    _textFieldBgColor = textFieldBgColor;
    _searchField.backgroundColor = textFieldBgColor;
    [_searchBar setSearchFieldBackgroundImage:[UIImage createImageWithColor:textFieldBgColor size:_searchBar.size radius:4] forState:UIControlStateNormal];
    
}

- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _searchBar.layer.masksToBounds = YES;
        
//        searchFieldd = [_searchBar valueForKey:@"_searchField"];
        _searchBar.returnKeyType = UIReturnKeySearch;
        
        [[[[_searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        [_searchBar setImage:[UIImage imageNamed:@"new_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [_searchBar setImage:[UIImage imageNamed:@"new_serach_deleate"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
        [_searchBar setImage:[UIImage imageNamed:@"new_serach_deleate"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
        _searchField = [_searchBar valueForKey:@"_searchField"];

    }
    return _searchBar;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.searchBar.placeholder = placeholder;
}

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
    self.searchBar.delegate = delegate;
}
- (void)setShowsCancelButton:(BOOL)showsCancelButton animated:(BOOL)animated
{
    [self.searchBar setShowsCancelButton:showsCancelButton animated:animated];
}

- (BOOL)isFirstResponder
{
    return self.searchBar.isFirstResponder;
}

- (BOOL)resignFirstResponder
{
    return [self.searchBar resignFirstResponder];
}
- (BOOL)becomeFirstResponder
{
    return  [self.searchBar becomeFirstResponder];
}

- (NSString *)text
{
    return self.searchBar.text;
}

- (void)setText:(NSString *)text
{
    text = text;
    self.searchBar.text = text;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

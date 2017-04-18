//
//  HandleNavigationBarViewController.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/7.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "HandleNavigationBarViewController.h"

@interface HandleNavigationBarViewController ()

@end

@implementation HandleNavigationBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 设置导航栏右侧按钮title
- (void)setRightItemWithTitle:(NSString*)title
{
    [self setRightItemsWithTitles:@[title]];
}
- (void)setRightItemsWithTitles:(NSArray *)titles
{
    NSMutableArray * items = [NSMutableArray array];
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize: 17.0];
        [btn sizeToFit];
        btn.tag = [titles indexOfObject:title];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(navibarRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem * item=[[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
    }
    self.navigationItem.rightBarButtonItems = items;
}


// 设置导航栏左侧按钮图标
- (void)setLeftItemImageName:(NSString*)imageName
{
    if (imageName) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(navibarLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * item=[[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = item;
    }
}


// 设置导航栏右侧按钮图标
- (void)setRightItemImageName:(NSString*)imageName
{
    [self setRightItemsImageNames:@[imageName]];
}

//设置导航栏右侧多个按钮
- (void)setRightItemsImageNames:(NSArray *)imageNames
{
    NSMutableArray * items = [NSMutableArray array];
    for (NSString * imageName in imageNames) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
        btn.tag = [imageNames indexOfObject:imageName];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(navibarRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * item=[[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
    }
    self.navigationItem.rightBarButtonItems = items;
}

- (void)navibarLeftBtnClick:(UIButton*)leftBtn
{
    NSLog(@"左边按钮");
    [self navLeftItemClick:0];
}

- (void)navibarRightBtnClick:(UIButton*)rightBtn
{
    NSLog(@"右边按钮");
    [self navRightItemClick:rightBtn.tag];
}

- (void)navLeftItemClick:(NSInteger)index
{
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)navRightItemClick:(NSInteger)index
{
    
}


- (void)pushVC:(UIViewController *)vc
{
    [self pushVC:vc animated:YES];
}

- (void)pushVC:(UIViewController *)vc animated:(BOOL)animated
{
    [self.navigationController pushViewController:vc animated:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

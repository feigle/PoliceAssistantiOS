//
//  DDBaseViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/27.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDBaseViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface DDBaseViewController ()

@end

@implementation DDBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
        self.pagesize = 10;
        self.dataTotal = 9999;
        self.fistRequestData = YES;
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TableViewBg;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName,nil]];

    [self.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:5]} forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(doBackAction)];
    self.navigationItem.backBarButtonItem = item;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //设置导航栏左右标题的文字颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //默认带有一定透明效果，可以使用以下方法去除系统效果
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:DaohangCOLOR size:CGSizeMake(1, 1)]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    
}
- (void)doBackAction
{
    NSLog(@"viewControllers %lu\r\n",(unsigned long)self.navigationController.viewControllers.count);
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (BOOL)navigationShouldPopOnBackButton
{
    [self doBackAction];
    return NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}


- (void)returnObjectCallBlock:(__autoreleasing CallBackReturnObjectDataBlock)block
{
    self.retrunObjectBlock = block;
}

- (void)returnRefreshCallBlock:(__autoreleasing CallBackRefreshDataBlock)block
{
    self.retrunRefreshBlock = block;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc:%@",NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning:%@",NSStringFromClass([self class]));
    SDWebImageManager * sdm = [SDWebImageManager sharedManager];
    [sdm cancelAll];
    [sdm.imageCache clearMemory];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
//    [[YYImageCache sharedCache].memoryCache removeAllObjects];
}

@end

//
//  LHDCusstomCameraPreviewViewController.m
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/28.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import "LHDCusstomCameraPreviewViewController.h"
#import "LHDPreviewOneImageView.h"


@interface LHDCusstomCameraPreviewViewController ()

@property (nonatomic, copy) LHDCusstomCameraPreviewGetImageBlock getImageBlock;

@property (nonatomic, copy) DismissViewControllerCompletionBlock block;

@end

@implementation LHDCusstomCameraPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LHDPreviewOneImageView *photoView = [[LHDPreviewOneImageView alloc] initWithFrame:self.view.bounds andImage:_image];
//    photoView.autoresizingMask = (1 << 6) -1;
//    photoView.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:photoView];
    [self initControlBtn];

}

- (void)setImage:(UIImage *)image
{
    _image = image;
}


- (void)initControlBtn {
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50.0f, self.view.frame.size.width, 50)];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.3;
    [bgView addSubview:alphaView];
    
    bgView.userInteractionEnabled = YES;
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.titleLabel.textColor = [UIColor blackColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [cancelBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cancelBtn.titleLabel setNumberOfLines:0];
    [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100.0f, 0, 100, 50)];
    confirmBtn.backgroundColor = [UIColor clearColor];
    confirmBtn.titleLabel.textColor = [UIColor blackColor];
    
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [confirmBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    confirmBtn.titleLabel.textColor = [UIColor blackColor];
    [confirmBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [confirmBtn.titleLabel setNumberOfLines:0];
    [confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:confirmBtn];
    
}
//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
////    NSLog(@"%@", NSStringFromCGRect([[[self.view subviews] lastObject] frame]));
//}


#pragma mark - 取消按钮
- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.block) {
            self.block(YES);
        }
    }];
}

- (void)dismissVCBlock:(DismissViewControllerCompletionBlock)block
{
    self.block = block;
}
#pragma mark - 确定按钮
- (void)confirm:(id)sender {
    WeakSelf
    [self dismissViewControllerAnimated:NO completion:^{
        StrongSelf
        strongSelf.getImageBlock(strongSelf,strongSelf.image);
        if (strongSelf.block) {
            strongSelf.block(YES);
        }
    }];
}

- (void)getCusstomCameraPreviewImageBlock:(LHDCusstomCameraPreviewGetImageBlock)block
{
    self.getImageBlock = block;
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

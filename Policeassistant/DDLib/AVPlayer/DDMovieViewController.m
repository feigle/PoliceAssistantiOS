//
//  DDMovieViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/9/8.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDMovieViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "DDAVPlayerView.h"
@interface DDMovieViewController ()
{
    UIView *bgView;
}
@property (nonatomic, strong) DDAVPlayerView *playerView;

@end

@implementation DDMovieViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerView];
}

- (DDAVPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[DDAVPlayerView alloc]init];
    }
    return _playerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)];
    [self.view addSubview:bgView];
    self.playerView.frame = bgView.bounds;
    [bgView addSubview:self.playerView];
    [self.playerView setAlpha:0];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLabelText:) name:@"GoBackVCNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NarrowScreen:) name:@"NarrowScreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopMovie) name:UIApplicationWillResignActiveNotification object:nil];
}
- (void)showLabelText:(NSNotification *)notification
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)NarrowScreen:(NSNotification *)notification
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)stopMovie{
    NSLog(@"视频要暂停");
    if (self.playerView.isPlaying) {
        [self.playerView pause];
    }
}
#pragma mark - 横屏代码
- (BOOL)shouldAutorotate{
    return NO;
} //NS_AVAILABLE_IOS(6_0);当前viewcontroller是否支持转屏

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
} //当前viewcontroller支持哪些转屏方向

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)prefersStatusBarHidden
{
    return NO; // 返回NO表示要显示，返回YES将hiden
}
#pragma mark----屏幕手动旋转

-(void)playviedo{
    [self.playerView setAlpha:1];
    // self.playerView.playerUrl = [NSURL URLWithString:@"https://doordustorage.oss-cn-shenzhen.aliyuncs.com/cctvVideo/DD312EN201603-35/2016/06/18/1466236496_2"];
    self.playerView.playerUrl = [NSURL URLWithString:@"http://api.feixiong.tv/Api/Base/getShortM3u8?params=%7B%22data%22%3A%7B%22id%22%3A281%2C%22stream_type%22%3A%22hd2%22%2C%22ykss%22%3A%22%22%7D%7D"];
    [self.playerView play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"%@--%@",object,[change description]);
}



@end

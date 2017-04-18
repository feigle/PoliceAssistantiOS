//
//  DDAVPlayerView.m
//  Policeassistant
//
//  Created by DoorDu on 16/9/7.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDAVPlayerView.h"
#import "DDPlayProgressView.h"
#import <AVFoundation/AVFoundation.h>
#import "DDMovieHeadView.h"

#define Bottom_Height  (self.bounds.size.height * 0.18)
@interface DDAVPlayerView()

@property (nonatomic, strong) AVPlayerLayer           *avPlayerLayer;
@property (nonatomic, strong) AVPlayer                *avPlayer;
@property (nonatomic, strong) AVPlayerItem            *playerItem;
@property (nonatomic, strong) DDPlayProgressView      *progressView;
@property (nonatomic, strong) DDMovieHeadView         *headView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIButton                *resumeBtn;
@property (nonatomic, strong) UIView                  *xzSuperView;
@property (nonatomic, assign) BOOL                    canEditProgressView;
@property (nonatomic, assign) BOOL                    canEditHeadView;
@property (nonatomic, assign) BOOL                    isDragSlider;
@property (nonatomic, assign) BOOL                    isFullScreen;

@end

@implementation DDAVPlayerView
- (instancetype)init{
    self = [super init];
    if (self) {
        //      [self setVolum];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setVolum];
    }
    return self;
}
- (UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc]init];
        _activityView.bounds = self.bounds;
        _activityView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [_activityView stopAnimating];
        _activityView.hidesWhenStopped = YES;
        _activityView.userInteractionEnabled = NO;
        [self addSubview:_activityView];
    }
    return _activityView;
}
- (DDPlayProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[DDPlayProgressView alloc]init];
        _progressView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _progressView.frame = CGRectMake(0, self.bounds.size.height - Bottom_Height, self.bounds.size.width, Bottom_Height);
        [_progressView.playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_progressView.fullBtn addTarget:self action:@selector(fullBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_progressView.progressSlider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_progressView.progressSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_progressView.progressSlider addTarget:self action:@selector(sliderCancled:) forControlEvents:UIControlEventTouchCancel];
        [_progressView.progressSlider addTarget:self action:@selector(sliderTouchInside:) forControlEvents:UIControlEventTouchUpInside];
        [_progressView.progressSlider addTarget:self action:@selector(sliderTouchOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:_progressView];
    }
    return _progressView;
}
- (DDMovieHeadView *)headView{
    if (!_headView) {
        _headView = [[DDMovieHeadView alloc]init];
        _headView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _headView.frame = CGRectMake(0, 0, self.bounds.size.width, Bottom_Height);
        [_headView.backBtn addTarget:self action:@selector(GoBackBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_headView];
        _headView.alpha=0;
    }
    return _headView;
    
}
- (UIButton *)resumeBtn{
    if (!_resumeBtn) {
        _resumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resumeBtn.hidden = YES;
        _resumeBtn.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
        _resumeBtn.frame = self.bounds;
        [_resumeBtn setImage:[UIImage imageNamed:@"icon_repeat_video"] forState:UIControlStateNormal];
        [_resumeBtn setImageEdgeInsets:UIEdgeInsetsMake(self.bounds.size.height / 2.0 - 37.0, self.bounds.size.width / 2.0 - 25.0, self.bounds.size.height / 2.0 - 37.0, self.bounds.size.width / 2.0 - 25.0)];
        [_resumeBtn addTarget:self action:@selector(resumeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_resumeBtn];
    }
    [self bringSubviewToFront:_resumeBtn];
    return _resumeBtn;
}
- (void)setVolum{
    self.clipsToBounds = YES;
    self.isShowBottomProgressView = YES;
    self.isShowResumViewAtPlayEnd = YES;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback
             withOptions:AVAudioSessionCategoryOptionMixWithOthers
                   error:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarWillChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterbackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CloseMovie:) name:@"GoBackVCNotification" object:nil];

}

- (void)CloseMovie:(NSNotification *)notification
{
    [self.avPlayer pause];
}
- (void)moviestartnext{
 //   [self.avPlayer replaceCurrentItemWithPlayerItem:nil];
    if (_isShowResumViewAtPlayEnd) {
        self.resumeBtn.hidden=YES;
    }
    
}
- (void)deletemovie{
    [_avPlayer replaceCurrentItemWithPlayerItem:_playerItem];
}
- (void)setPlayerUrl:(NSURL *)playerUrl{
    if (playerUrl) {
        _playerUrl = playerUrl;
        if (_avPlayer) {
            [_avPlayer pause];
            [_avPlayerLayer removeFromSuperlayer];
            [self.playerItem removeObserver:self forKeyPath:@"status"];
            [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
            _totalDuration = 0.0f;
            _timeInterval = 0.0f;
            _currentPlayTime = 0.0f;
        }
        self.canEditProgressView = YES;
        self.canEditHeadView=YES;
        [self hiddenProgressView:NO];
        [self hiddenHeadView:NO];
        self.canEditProgressView = NO;
        self.canEditHeadView=NO;
        [self.activityView startAnimating];
        _playerItem = [[AVPlayerItem alloc]initWithURL:playerUrl];
        _avPlayer = [[AVPlayer alloc]initWithPlayerItem:_playerItem];
        _avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
        _avPlayerLayer.backgroundColor = [UIColor blackColor].CGColor;
        [(AVPlayerLayer *)self.layer addSublayer:_avPlayerLayer];
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//监听status属性
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];//监听loadedTimeRanges属性
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(currentXCPlayerTime) object:nil];
        [self currentXCPlayerTime];
        
        [self bringSubviewToFront:self.progressView];
        [self bringSubviewToFront:self.headView];
        [self bringSubviewToFront:self.activityView];
    }
}
- (void)setIsShowBottomProgressView:(BOOL)isShowBottomProgressView{
    _isShowBottomProgressView = isShowBottomProgressView;
    self.progressView.hidden = !isShowBottomProgressView;
    self.headView.hidden = !isShowBottomProgressView;
}

- (void)setIsShowResumViewAtPlayEnd:(BOOL)isShowResumViewAtPlayEnd{
    _isShowResumViewAtPlayEnd = isShowResumViewAtPlayEnd;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_avPlayerLayer) {
        _avPlayerLayer.frame = self.bounds;
    }
    CGRect frame = self.progressView.frame;
    self.progressView.frame = CGRectMake(frame.origin.x, self.bounds.size.height - Bottom_Height, self.bounds.size.width, Bottom_Height);
    self.headView.frame = CGRectMake(frame.origin.x, 0, self.bounds.size.width, Bottom_Height);
    self.activityView.bounds = self.bounds;
    self.activityView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    self.resumeBtn.frame = self.bounds;
}

/** 播放 */
- (void)play{
    if (_avPlayer) {
        [_avPlayer play];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(currentXCPlayerTime) object:nil];
        [self performSelector:@selector(currentXCPlayerTime) withObject:nil afterDelay:0.5];
    }
}

/** 暂停 */
- (void)pause{
    if (_avPlayer) {
        [_avPlayer pause];
    }
}

/** 重新开始 */
- (void)resume{
    [self.avPlayer seekToTime:kCMTimeZero];
    if (self.avPlayer.rate == 0.0) {
        [self.avPlayer play];
    }
}

/** 播放状态 */
- (BOOL)isPlaying{
    if (self.avPlayer.rate == 0) {
        return NO;
    }
    return YES;
}

- (void)playBtnClicked:(UIButton *)sender{
    if (self.avPlayer.rate != 0) {
        [self pause];
        [self.progressView.playBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
    }else{
        [self play];
        [self.progressView.playBtn setImage:[UIImage imageNamed:@"av_start"] forState:UIControlStateNormal];
    }
}

- (void)resumeBtnClicked:(UIButton *)sender{
    [self resume];
    sender.hidden = YES;
}

- (void)fullBtnClicked:(UIButton *)sender{
    if (_isFullScreen==NO) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FullScreenNotification" object:nil];
        [_headView setAlpha:1];
        _headView.scrollLabel.text=_head_label;
        _isFullScreen=YES;
    //    NSLog(@"放大：宽：%f  高：%f",self.frame.size.width,self.frame.size.height);
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NarrowScreenNotification" object:nil];
        [_headView setAlpha:0];
        _isFullScreen=NO;
        CGRect frame = self.frame;
        frame.size.height = frame.size.width*9/16;
        self.frame = frame;
      //  NSLog(@"缩小：宽：%f  高：%f",self.frame.size.width,self.frame.size.height);
    }

}

-(void)GoBackBtnClicked:(UIButton*)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"GoBackVCNotification" object:nil];
}
- (void)sliderTouchDown:(UISlider *)sender{
    _isDragSlider = YES;
}
- (void)sliderValueChanged:(UISlider *)sender{
    _isDragSlider = YES;
    self.progressView.currentTimeLabel.text = [self convertTimeToString:self.progressView.progressSlider.value];
}
- (void)sliderCancled:(UISlider *)sender{
    _isDragSlider = NO;
}
- (void)sliderTouchInside:(UISlider *)sender{
    [self seekToTime:self.progressView.progressSlider.value];
    _isDragSlider = NO;
}
- (void)sliderTouchOutside:(UISlider *)sender{
    _isDragSlider = NO;
}
/** 播放时间 00:00:00 */
- (NSString *)convertTimeToString:(CGFloat)second{
    NSDate *pastDate = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *timeString = [formatter stringFromDate:pastDate];
    return timeString;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"XCPlayerStatusReadyToPlay");
            self.totalDuration = floorf(CMTimeGetSeconds(self.playerItem.duration));
            self.progressView.totalDurationLabel.text = [self convertTimeToString:self.totalDuration];
            self.progressView.progressSlider.maximumValue = self.totalDuration;
            self.progressView.progressSlider.minimumValue = 0;
            self.canEditProgressView = YES;
            self.canEditHeadView=YES;
            [self showProgressView:NO];
            [self showHeadView:NO];
            [self.activityView stopAnimating];
            if (self.delegate && [self.delegate respondsToSelector:@selector(xcAVPlayerView:reloadStatuesChanged:)]) {
                [self.delegate xcAVPlayerView:self reloadStatuesChanged:DDPlayerStatusReadyToPlay];
            }
        }else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"XCPlayerStatusFailed");
            [DDProgressHUD showCenterWithText:@"视频加载失败,请检查网络后重试" duration:2.0];
            [self.activityView stopAnimating];
            if (self.delegate && [self.delegate respondsToSelector:@selector(xcAVPlayerView:reloadStatuesChanged:)]) {
                [self.delegate xcAVPlayerView:self reloadStatuesChanged:DDPlayerStatusFailed];
            }
        }else if ([playerItem status] == AVPlayerStatusUnknown){
            NSLog(@"XCPlayerStatusUnknown");
            [self.activityView stopAnimating];
            if (self.delegate && [self.delegate respondsToSelector:@selector(xcAVPlayerView:reloadStatuesChanged:)]) {
                [self.delegate xcAVPlayerView:self reloadStatuesChanged:DDPlayerStatusUnknown];
            }
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];//计算缓冲进度
        self.timeInterval = timeInterval;
        self.progressView.timeIntervalProgress.progress = self.timeInterval / self.totalDuration;
        //    NSLog(@"Time Interval:%f",timeInterval);
    }
}

- (void)currentXCPlayerTime{
    self.currentPlayTime = floorf(CMTimeGetSeconds(self.playerItem.currentTime));
    if (self.currentPlayTime < 0) {
        self.currentPlayTime = 0.0;
    }
    if (self.avPlayer.rate != 0) {
        [self.progressView.playBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
    }else{
        [self.progressView.playBtn setImage:[UIImage imageNamed:@"av_start"] forState:UIControlStateNormal];
    }
    if (!_isDragSlider) {
        self.progressView.progressSlider.value = self.currentPlayTime;
        self.progressView.currentTimeLabel.text = [self convertTimeToString:self.currentPlayTime];
    }
  //  NSLog(@"current playTime:%f－－status:%ld",self.currentPlayTime,(long)self.playerItem.status);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(currentXCPlayerTime) object:nil];
    [self performSelector:@selector(currentXCPlayerTime) withObject:nil afterDelay:0.5];
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.avPlayer currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

/** 拉动进度条 */
- (void)seekToTime:(CGFloat)seekTime{
    if (_avPlayer) {
        CMTime time = CMTimeMake(seekTime * self.playerItem.currentTime.timescale, self.playerItem.currentTime.timescale);
        [_avPlayer seekToTime:time];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_isShowBottomProgressView) {
        if ([self.progressView isHidden]) {
            [self showProgressView:YES];
            [self showHeadView:YES];
            
        }else{
            [self hiddenProgressView:YES];
            [self hiddenHeadView:YES];
        }
    }
}

#pragma mark---up head view
- (void)hiddenHeadView:(BOOL)animate{
    if (!_canEditHeadView) {
        return;
    }
    _canEditHeadView = NO;
    if (animate) {
        [UIView animateWithDuration:0.2 animations:^{
            self.headView.frame = CGRectMake(0, -self.headView.bounds.size.height, self.headView.bounds.size.width, self.headView.bounds.size.height);
        } completion:^(BOOL finished) {
            self.headView.hidden = YES;
            self.canEditHeadView = YES;
        }];
    }else{
        self.headView.hidden = YES;
        self.canEditHeadView = YES;
        self.headView.frame = CGRectMake(0, 0, self.headView.bounds.size.width, self.headView.bounds.size.height);
    }
    
}

- (void)showHeadView:(BOOL)animate{
    if (!_canEditHeadView) {
        return;
    }
    _canEditHeadView = NO;
    self.headView.hidden = NO;
    if (animate) {
        [UIView animateWithDuration:0.2 animations:^{
            self.headView.frame = CGRectMake(0, 0, self.bounds.size.width, Bottom_Height);
        } completion:^(BOOL finished) {
            self.canEditHeadView = YES;
        }];
    }else{
        self.headView.frame = CGRectMake(0, 0, self.bounds.size.width, Bottom_Height);
        self.canEditHeadView = YES;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenHeadView:) object:self];
    [self performSelector:@selector(hiddenHeadView:) withObject:self afterDelay:3.0];
}

#pragma mark---bottom progress view
- (void)hiddenProgressView:(BOOL)animate{
    if (!_canEditProgressView) {
        return;
    }
    _canEditProgressView = NO;
    if (animate) {
        [UIView animateWithDuration:0.2 animations:^{
            self.progressView.frame = CGRectMake(0, self.bounds.size.height, self.progressView.bounds.size.width, self.progressView.bounds.size.height);
        } completion:^(BOOL finished) {
            self.progressView.hidden = YES;
            self.canEditProgressView = YES;
        }];
    }else{
        self.progressView.hidden = YES;
        self.canEditProgressView = YES;
        self.progressView.frame = CGRectMake(0, self.bounds.size.height, self.progressView.bounds.size.width, self.progressView.bounds.size.height);
    }
    
}

- (void)showProgressView:(BOOL)animate{
    if (!_canEditProgressView) {
        return;
    }
    _canEditProgressView = NO;
    self.progressView.hidden = NO;
    if (animate) {
        [UIView animateWithDuration:0.2 animations:^{
            self.progressView.frame = CGRectMake(0, self.bounds.size.height - Bottom_Height, self.bounds.size.width, Bottom_Height);
        } completion:^(BOOL finished) {
            self.canEditProgressView = YES;
        }];
    }else{
        self.progressView.frame = CGRectMake(0, self.bounds.size.height - Bottom_Height, self.bounds.size.width, Bottom_Height);
        self.canEditProgressView = YES;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenProgressView:) object:self];
    [self performSelector:@selector(hiddenProgressView:) withObject:self afterDelay:3.0];
}

#pragma notification
- (void)playerPlayToEnd:(NSNotification *)notification{
    NSLog(@"play end");
    [self pause];
    [self.avPlayer seekToTime:kCMTimeZero];
    [self.progressView.playBtn setImage:[UIImage imageNamed:@"av_play"] forState:UIControlStateNormal];
    self.canEditProgressView = YES;
    self.canEditHeadView=YES;
    [self hiddenProgressView:NO];
    [self hiddenHeadView:NO];
    self.resumeBtn.hidden = !_isShowResumViewAtPlayEnd;
    [_resumeBtn setBackgroundImage:[DDTools buttonImageFromColor:RGB(73, 74, 75)] forState:UIControlStateNormal];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(xcAVPlayerView:reloadStatuesChanged:)]) {
        [self.delegate xcAVPlayerView:self reloadStatuesChanged:DDPlayerStatusPlayEnd];
    }
}

- (void)statusBarWillChanged:(NSNotification *)notification{
    //   NSLog(@"%d",[UIApplication sharedApplication].statusBarOrientation);
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        if (self.superview != [UIApplication sharedApplication].keyWindow) {
            self.xzSuperView = self.superview;
        }
        if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
            [[UIApplication sharedApplication].keyWindow addSubview:self];
            self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        }
    }else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
        if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
            [self removeFromSuperview];
        }
        if (![self.xzSuperView.subviews containsObject:self]) {
            [self.xzSuperView addSubview:self];
        }
        self.frame = self.xzSuperView.bounds;
    }
}

- (void)applicationEnterbackground:(NSNotification *)notification{
    if ([self isPlaying]) {
        [self pause];
    }
}


- (void)dealloc{
    [self pause];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end

//
//  DDAVPlayerView.h
//  Policeassistant
//
//  Created by DoorDu on 16/9/7.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DDAVPlayerStatues){
    DDPlayerStatusReadyToPlay,
    DDPlayerStatusFailed,
    DDPlayerStatusUnknown,
    DDPlayerStatusPlayEnd,
};

@class DDAVPlayerView;

@protocol DDAVPlayerDelegate <NSObject>

/** 播放器状态改变 */
- (void)xcAVPlayerView:(DDAVPlayerView *)playerView reloadStatuesChanged:(DDAVPlayerStatues)xcPlayerStatues;

/** 播放时间进度改变 */
- (void)xcAVPlayerView:(DDAVPlayerView *)playerView currentPlayTimeChanged:(Float64)currentPlayTime;

@end

@interface DDAVPlayerView : UIView
@property (nonatomic, strong) NSURL *playerUrl;/**< 播放链接 */
@property (nonatomic, strong) NSString *head_label;//头部文字
@property (nonatomic, strong) UIImage *FirstImg;/**< 播放链接 */
@property (nonatomic, assign) id<DDAVPlayerDelegate> delegate;
@property (nonatomic, assign) Float64 currentPlayTime;/**< current play time */
@property (nonatomic, assign) Float64 totalDuration;/**< video duration */
@property (nonatomic, assign) Float64 timeInterval;/**< available Duration (cached) */

@property (nonatomic, assign) BOOL    isShowBottomProgressView;/**< default is YES */
@property (nonatomic, assign) BOOL    isShowResumViewAtPlayEnd;/**< default is YES */


/** 播放状态 */
- (BOOL)isPlaying;

/** play */
- (void)play;

/** pause */
- (void)pause;

/** resume */
- (void)resume;

/** 拉动进度条 */
- (void)seekToTime:(CGFloat)seekTime;

/**
 播放下一个
 */
- (void)moviestartnext;
//释放资源
- (void)deletemovie;
/** 播放时间 00:00:00 */
- (NSString *)convertTimeToString:(CGFloat)second;
@end

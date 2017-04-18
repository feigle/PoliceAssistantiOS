//
//  DDPlayProgressView.h
//  Policeassistant
//
//  Created by DoorDu on 16/9/7.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDPlayProgressView : UIView
@property (nonatomic, strong) UIButton       *playBtn;
@property (nonatomic, strong) UIButton       *fullBtn;
@property (nonatomic, strong) UISlider       *progressSlider;
@property (nonatomic, strong) UILabel        *currentTimeLabel;
@property (nonatomic, strong) UILabel        *totalDurationLabel;
@property (nonatomic, strong) UIProgressView *timeIntervalProgress;
@end

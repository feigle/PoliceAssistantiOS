//
//  DDPopView.m
//  tabbar
//
//  Created by DoorDu on 16/6/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DDPopView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DDAVPlayerView.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define WINDOWFirst        [[[UIApplication sharedApplication] windows] firstObject]
#define AlertViewJianGe KScreenWidth/20
@interface DDPopView ()<UIScrollViewDelegate>
{
    UIButton *play_btn,*btn1,*btn2;
    UIView *currentView;
    NSString *DoorType,*UserType;
    int currrnt_page,scroll_page,num_page;
    NSArray *data_array;
    NSString *stringtype;
    UIButton *_preBtn;//当前的状态
}
@property (nonatomic, strong) DDAVPlayerView *playerView;
@property (nonatomic,strong)UIScrollView *scrollView;

@end
@implementation DDPopView
- (DDAVPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[DDAVPlayerView alloc]init];
    }
    return _playerView;
}
-(instancetype)initWithTimeText:(NSString *)timelable type:(NSString*)type WithArray:(NSArray*)array
{
    self=[super init];
    if (self) {
        if (self.bGView==nil) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.7;
            [WINDOWFirst addSubview:view];
            self.bGView =view;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonClick)];
            [self.bGView addGestureRecognizer:tap];
        }
        self.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
        CGFloat heit;
        if (iPhone6P) {
            heit=KScreenHeight*0.6;
        }else if (iPhone6){
            heit=KScreenHeight*0.65;
        }else{
            heit=KScreenHeight*0.7;
        }
        self.bounds = CGRectMake(0, 10, KScreenWidth-2*AlertViewJianGe, heit);
        [WINDOWFirst addSubview:self];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.backgroundColor=[UIColor whiteColor];
        int pageContorlCount=(int)array.count;
        for (int i = 0 ; i <array.count; i++) {
            if ([timelable isEqualToString:[array objectAtIndex:i][@"log_time"]]) {
                NSLog(@"------%d",i);
                currrnt_page=i;
            }
        }
        data_array=array;
        _scrollView=[[UIScrollView alloc]init];
        _scrollView.frame=CGRectMake(10, 20, KScreenWidth*0.9-20, heit-20);
        CGFloat width=self.scrollView.frame.size.width;
        CGFloat height=self.scrollView.frame.size.height;
        [self addSubview:_scrollView];
        for (int i=0; i<array.count; i++) {
            currentView=[[UIView alloc]initWithFrame:CGRectMake(i*width, 0, width, height)];
            NSString *picstr=[NSString stringWithFormat:@"%@",[array objectAtIndex:i][@"pic"]];
            
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width*9/16)];
            [_imageView sd_setImageWithURL:[NSURL URLWithString:picstr] placeholderImage:[UIImage imageNamed:@"base_empty"] options:SDWebImageAllowInvalidSSLCertificates];
            _imageView.userInteractionEnabled=YES;
            
            
            [currentView addSubview:_imageView];
            UILabel *lab1=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:DaohangCOLOR myfram:CGRectMake(15, CGRectGetMaxY(_imageView.frame)+15, width-30, 20) mytext:[NSString stringWithFormat:@"%@",[array objectAtIndex:i][@"log_time"]]];
            [currentView addSubview:lab1];
            
            NSDictionary *dict=[array objectAtIndex:i];
            stringtype=[self stringForDIc:dict];
            
            UILabel *lab2=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:MAINTEX myfram:CGRectMake(15, CGRectGetMaxY(lab1.frame), width-30, 40) mytext:stringtype];
            lab2.numberOfLines=0;
            [currentView addSubview:lab2];
            
            if ([type isEqualToString:@"2"]) {
                _imageView.image=nil;
                play_btn=[[UIButton alloc]init];
                play_btn.frame=_imageView.bounds;
                [_imageView addSubview:play_btn];
                [play_btn setImage:[UIImage imageNamed:@"av_start@3x"] forState:UIControlStateNormal];
                UIImage *image1=[DDTools buttonImageFromColor:RGB(73, 74, 75)];
                [play_btn setBackgroundImage:image1 forState:UIControlStateNormal];
                [play_btn addTarget:self action:@selector(starttoplay:) forControlEvents:UIControlEventTouchUpInside];
                [self.playerView setAlpha:0];
                self.playerView.head_label=stringtype;
                play_btn.tag=1000+i;
            }

            UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab2.frame), width, 1)];
            line.backgroundColor=LINECOLOR;
            [currentView addSubview:line];
            
            UILabel *lab3=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:MAINTEX myfram:CGRectMake(15, CGRectGetMaxY(line.frame)+10, 70, 20) mytext:@"身份证号"];
            [currentView addSubview:lab3];
            
            UILabel *lab4=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:TEXCOLOR myfram:CGRectMake(85, CGRectGetMaxY(line.frame)+10, width-85, 20) mytext:[NSString stringWithFormat:@"%@",[array objectAtIndex:i][@"card_no"]]];
            [currentView addSubview:lab4];
            
            UILabel *lab5=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:MAINTEX myfram:CGRectMake(15, CGRectGetMaxY(lab3.frame)+10, 70, 20) mytext:@"入住时间"];
            [currentView addSubview:lab5];
            
            NSString *time=[NSString stringWithFormat:@"%@",[array objectAtIndex:i][@"create_time"]];
            NSString *use=[time substringToIndex:11];
            UILabel *lab6=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:TEXCOLOR myfram:CGRectMake(85, CGRectGetMaxY(lab3.frame)+10, width-85, 20) mytext:use];
            [currentView addSubview:lab6];
            
            UILabel *lab7=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:MAINTEX myfram:CGRectMake(15, CGRectGetMaxY(lab5.frame)+10, 70, 20) mytext:@"户籍地址"];
            [currentView addSubview:lab7];
            NSString *birstr=[NSString stringWithFormat:@"%@",[array objectAtIndex:i][@"birth_place"]];
            NSArray *b = [birstr componentsSeparatedByString:@"市"];
            NSString *str_bir=[NSString stringWithFormat:@"%@市",[b firstObject]];
            UILabel *lab8=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:TEXCOLOR myfram:CGRectMake(85, CGRectGetMaxY(lab5.frame)+10, width-85, 20) mytext:str_bir];
            [currentView addSubview:lab8];
            
            UILabel *lab9=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:MAINTEX myfram:CGRectMake(15, CGRectGetMaxY(lab7.frame)+10, 70, 20) mytext:@"现居地址"];
            [currentView addSubview:lab9];
            
            UILabel *lab10=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:TEXCOLOR myfram:CGRectMake(85, CGRectGetMaxY(lab7.frame)+10, width-100, 20) mytext:[NSString stringWithFormat:@"%@",[array objectAtIndex:i][@"nowaddress"]]];
            lab10.numberOfLines=0;
            CGSize maximumLabelSize = CGSizeMake(width-100, 9999);//labelsize的最大值
            CGSize expectSize = [lab10 sizeThatFits:maximumLabelSize];
            lab10.frame = CGRectMake(85, CGRectGetMaxY(lab7.frame)+12, expectSize.width, expectSize.height);
            [currentView addSubview:lab10];
            self.scrollView.contentSize=CGSizeMake(pageContorlCount*width, 0);
            self.scrollView.pagingEnabled=YES;
            self.scrollView.delegate=self;
            [self.scrollView addSubview:currentView];

        }
        [self show:YES];
        [_scrollView setContentOffset:CGPointMake(currrnt_page*width,0) animated:YES];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopMovie) name:UIApplicationWillResignActiveNotification object:nil];
         }
    return self;
}
- (void)stopMovie{
    if (self.playerView.isPlaying) {
        [self.playerView pause];
    }
}

/**
 滚动完成代理

 @param scrollView 滚动完成后判断角标然后做视频相关操作
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int pagenum= (self.scrollView.contentOffset.x+1)/self.scrollView.frame.size.width;
    if (num_page==pagenum) {
        NSLog(@"%d-==不响应===%d",num_page,pagenum);
    }else {
     
        num_page=pagenum;
        if ([self.playerView isPlaying]) {
            [self.playerView pause];
        }
        
        [self.playerView moviestartnext];
        [self.playerView setAlpha:0];
        _preBtn.alpha=1;
        NSLog(@"%d+++播放上一个下一个++++%d",num_page,pagenum);

    }
}
/**
 *  播放视频
 */

- (void)starttoplay:(UIButton *)sender{
//    NSLog(@"%ld---------%@",(long)sender.tag,data_array);
    NSString *Urlstr=[NSString stringWithFormat:@"%@",[data_array objectAtIndex:sender.tag-1000][@"pic"]];
    NSDictionary *dic=[data_array objectAtIndex:sender.tag-1000];
    self.playerView.head_label=[self stringForDIc:dic];
    _preBtn.alpha=1;
    sender.alpha=0;
    _preBtn = sender;
    CGFloat width=self.scrollView.frame.size.width;
    self.playerView.frame = CGRectMake(width*(sender.tag-1000), 0, width, width*9/16);
    [self.scrollView addSubview:self.playerView];
    [self.playerView setAlpha:1];
 //   self.playerView.playerUrl = [NSURL URLWithString:@"http://api.feixiong.tv/Api/Base/getShortM3u8?params=%7B%22data%22%3A%7B%22id%22%3A281%2C%22stream_type%22%3A%22hd2%22%2C%22ykss%22%3A%22%22%7D%7D"];
    self.playerView.playerUrl = [NSURL URLWithString:Urlstr];
    [self.playerView play];

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"%@--%@",object,[change description]);
}
- (NSString *)stringForDIc:(NSDictionary *)dic{
    NSString *str2=[NSString stringWithFormat:@"%@",dic[@"type"]];
    NSString *str3=[NSString stringWithFormat:@"%@",dic[@"user_type"]];
    switch ([str3 intValue]) {
        case 0:
            UserType=@"业主";
            break;
        case 1:
            UserType=@"家人";
            break;
        case 2:
            UserType=@"租客";
            break;
        case 3:
            UserType=@"临时客人";
            break;
        default:
            break;
    }
    
    switch ([str2 intValue]) {
        case 1:
            DoorType=[NSString stringWithFormat:@"使用IC卡开启了"];
            break;
        case 2:
            DoorType=[NSString stringWithFormat:@"使用APP开启了"];
            break;
        case 3:
            DoorType=[NSString stringWithFormat:@"被呼叫接通后开"];
            break;
        case 4:
            DoorType=[NSString stringWithFormat:@"使用临时密码开启了"];
            break;
        case 5:
            DoorType=[NSString stringWithFormat:@"主动查看门禁视频开启了"];
            break;
        case 6:
            DoorType=[NSString stringWithFormat:@"被呼叫未接通时开"];
            break;
        case 7:
            DoorType=[NSString stringWithFormat:@"没开"];
            break;
            
        default:
            break;
    }
    NSString *doorstr=[NSString stringWithFormat:@"%@",dic[@"name"]];
    NSString *mainstr=[NSString stringWithFormat:@"%@(%@)%@%@",dic[@"user_name"],UserType,DoorType,doorstr];
    return mainstr;

}
/**
 *  点击灰色区域返回操作
 */
- (void)buttonClick{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"GoBackVCNotification" object:nil];
    [self.playerView deletemovie];
    [self hide:YES];
}

-(void)buttonClick:(UIButton*)button
{
    [self hide:YES];
    if (self.ButtonClick) {
        self.ButtonClick(@"123");
    }
}


- (void)show:(BOOL)animated
{
    if (animated)
    {
        self.transform = CGAffineTransformScale(self.transform,0,0);
        __weak DDPopView *weakSelf = self;
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 animations:^{
                weakSelf.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)hide:(BOOL)animated
{
    [self endEditing:YES];
    if (self.bGView != nil) {
        __weak DDPopView *weakSelf = self;
        
        [UIView animateWithDuration:animated ?0.3: 0 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1,1);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration: animated ?0.3: 0 animations:^{
                weakSelf.transform = CGAffineTransformScale(weakSelf.transform,0.2,0.2);
            } completion:^(BOOL finished) {
                [weakSelf.bGView removeFromSuperview];
                [weakSelf removeFromSuperview];
                weakSelf.bGView=nil;
            }];
        }];
    }
    
}

@end

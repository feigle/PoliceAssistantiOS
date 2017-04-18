//
//  DDCollectionViewCell.h
//  Policeassistant
//
//  Created by DoorDu on 16/8/8.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCollectionViewCell : UICollectionViewCell<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView *misslevbg;
@property (nonatomic,strong) UIImageView *clockbg;
@property (nonatomic,strong) UILabel *missidLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *typeLab;
@property (nonatomic,strong) UILabel *FilishLab;
@property (nonatomic,strong) UILabel *addressLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *startLab;
@property (nonatomic,strong) UIButton *acceptBtn;
@property (nonatomic,strong) UIButton *flishBtn;
- (void)adddic:(NSDictionary *)dic;
@end

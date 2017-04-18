//
//  DDHomeTableViewCell.m
//  tabbar
//
//  Created by DoorDu on 16/6/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DDHomeTableViewCell.h"

@implementation DDHomeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        self.Iconimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 20, 20)];
        self.Iconimg.image=[UIImage imageNamed:@"add_check_people_icon"];
        [self.contentView addSubview:self.Iconimg];
        
        self.TypeLab=[[DDLabel alloc]initWithAlertViewHeight:18 mycolor:MAINTEX myfram:CGRectMake(42.5, 18, width-100, 18) mytext:@"新增入住人数"];
        [self.contentView addSubview:self.TypeLab];
        
        self.PeopleLab=[[DDLabel alloc]initWithAlertViewHeight:18 mycolor:[UIColor colorWithRed:229/255.0f green:33/255.0f blue:18/255.0f alpha:1] myfram:CGRectMake(width-233, 17, 185, 18) mytext:@"0"];
        self.PeopleLab.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.PeopleLab];
        
        UILabel *templab=[[DDLabel alloc]initWithAlertViewHeight:18 mycolor:MAINTEX myfram:CGRectMake(width-48, 17, 18, 18) mytext:@"人"];
        templab.textAlignment=NSTextAlignmentRight;
        
        [self.contentView addSubview:templab];        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

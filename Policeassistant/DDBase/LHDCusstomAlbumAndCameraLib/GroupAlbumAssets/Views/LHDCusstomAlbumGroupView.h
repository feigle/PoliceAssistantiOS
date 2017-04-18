//
//  LHDCusstomAlbumGroupView.h
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/20.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LHDCusstomAlbumGroupModel.h"

typedef void (^SelectAlbumGroupBlock) (LHDCusstomAlbumGroupModel * groupModel);

@interface LHDCusstomAlbumGroupView : UIView

@property (nonatomic, strong) NSString * lastChoseGroupName;
@property (nonatomic, strong) LHDCusstomAlbumGroupModel * groupModel;

@property (nonatomic, assign) NSInteger groupNumber;//有几个组

- (void)selectedAlbumGroupBlock:(SelectAlbumGroupBlock)block;



@end

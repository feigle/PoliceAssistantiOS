//
//  LHDBaseViewController.h
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/10.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHDBaseViewController : UIViewController

- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;

- (void)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;


@end

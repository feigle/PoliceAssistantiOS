//
//  DDCollectionViewController.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/7.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "HttpRequestViewController.h"

@interface DDCollectionViewController : HttpRequestViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;

/**必须是流式布局才这样用*/
@property (nonatomic,strong) UICollectionViewLayout *customLayout;

@property (nonatomic,assign) UICollectionViewScrollDirection collectionDirection;


@end

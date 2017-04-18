//
//  DDCollectionViewController.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/7.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDCollectionViewController.h"

@interface DDCollectionViewController ()

@end

@implementation DDCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


//集合试图
- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64) collectionViewLayout:flowLayout];
        _collectionView.scrollsToTop = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (void)setCollectionDirection:(UICollectionViewScrollDirection)collectionDirection
{
    if ([self.collectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *flowLayout=(UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
        flowLayout.scrollDirection=collectionDirection;
    }else{
        NSLog(@"不能设置");
        return;
    }
}

- (void)setCustomLayout:(UICollectionViewLayout *)customLayout
{
    self.collectionView.collectionViewLayout = customLayout;
}

- (void)addHeaderRefresh
{
    [super addHeaderRefresh];
    [self.collectionView addSubview:self.headerRefreshControl];
}

- (void)addFootRefresh
{
    [super addFootRefresh];
    self.collectionView.mj_footer = self.footerRefreshControl;
    [self endFootRefreshNoMoreData];
}
- (void)beginHeaderRefresh
{
    [super beginHeaderRefresh];
    [self.collectionView setNeedsDisplay];
}

#pragma mark- collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"indentifier" forIndexPath:indexPath];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

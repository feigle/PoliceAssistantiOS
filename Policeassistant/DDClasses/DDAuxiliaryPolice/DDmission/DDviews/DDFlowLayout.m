//
//  DDFlowLayout.m
//  Policeassistant
//
//  Created by DoorDu on 16/8/8.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDFlowLayout.h"

@implementation DDFlowLayout
//第一个
- (void)prepareLayout
{
    [super prepareLayout];
}

//第三个
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //1.确定加载item的区域
    CGFloat  x =self.collectionView.contentOffset.x;
    CGFloat  y =0;
    CGFloat  w =self.collectionView.frame.size.width;
    CGFloat  h = self.collectionView.frame.size.height;
    CGRect myrect =CGRectMake(x, y, w, h);
    
    //2.获得这个区域的item
    // NSArray *arr =[super layoutAttributesForElementsInRect:myrect];
    
    NSArray *arr = [[NSArray alloc]initWithArray:[super layoutAttributesForElementsInRect:myrect] copyItems:YES];
  //  NSLog(@"arr111--===-==%@",arr);
    //遍历item,快到中间的时候放大，离开中间的时候收索
    for (UICollectionViewLayoutAttributes *atts in arr) {
        //1.获得item距离左边的边框的距离
        CGFloat leftdelta =atts.center.x -self.collectionView.contentOffset.x;
        
        //2.获得屏幕的中心点
        CGFloat centerX =self.collectionView.frame.size.width *0.5;
        
        //3.获得距离中心的距离
        CGFloat dela =fabs(centerX -leftdelta);
        
        //4.左边的item缩小
        // CGFloat leftscale =dela/centerX;
        CGFloat rightscale =1-dela/centerX;
        
        //5.缩放
        atts.transform =CGAffineTransformMakeScale(rightscale *0.1 +1 , rightscale *0.1 +1 );
        
    }
    return arr;
}




//第四个
//滚动的时候一直调用（相当于滚动间监听）
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;
{
    [super shouldInvalidateLayoutForBoundsChange:newBounds];
    return YES;
}



//第五个，停止滚动的时候调用
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //停止滚动的时候定位在中心
    //1.拿到区域内的cell
    //1.1.确定加载item的区域
    CGFloat  x =self.collectionView.contentOffset.x;
    CGFloat  y =0;
    CGFloat  w =self.collectionView.frame.size.width;
    CGFloat  h = self.collectionView.frame.size.height;
    CGRect myrect =CGRectMake(x, y, w, h);
    
    //1.2.获得这个区域的item
    NSArray *arr = [[NSArray alloc]initWithArray:[super layoutAttributesForElementsInRect:myrect] copyItems:YES];
    
   // NSLog(@"arr2222--===-==%@",arr);
    CGFloat mindelta =MAXFLOAT;
    for (UICollectionViewLayoutAttributes *atts in arr) {
        
        //2.计算距离中心点的距离
        //1.获得item距离左边的边框的距离
        CGFloat leftdelta =atts.center.x -proposedContentOffset.x;
        
        //2.获得屏幕的中心点
        CGFloat centerX =self.collectionView.frame.size.width *0.5;
        
        //3.获得距离中心的距离
        CGFloat dela =fabs(centerX -leftdelta);
        
        //4.获得最小的距离
        if(dela < mindelta)
            mindelta =centerX -leftdelta;
        
    }
    //定位在中心，注意是-号，回到之前的位置
    proposedContentOffset.x -=mindelta;
    CGFloat width=self.collectionView.frame.size.width*2/3*1.1;
    int pagecount=proposedContentOffset.x/width;
    NSString *pagenum=[NSString stringWithFormat:@"%d",pagecount];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"GetCurrentPageNotification" object:pagenum];
    return proposedContentOffset;
}



//第二个  接着会来第二次
- (CGSize)collectionViewContentSize
{
    //rNSLog(@"%s,line = %d",__FUNCTION__,__LINE__);
    return [super collectionViewContentSize];
}
@end

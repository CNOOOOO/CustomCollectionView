//
//  ItemZoomLayout.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/27.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "ItemZoomLayout.h"

#define SCALE 0.3

@implementation ItemZoomLayout

- (instancetype)init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return self;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    //proposedContentOffset是没有对齐到网格时建议停下的位置
    CGFloat offsetAdjustment = MAXFLOAT;
    //预期滚动停止时水平方向的中心点
    CGFloat horizontalCenter = proposedContentOffset.x + CGRectGetWidth(self.collectionView.bounds) / 2.0;
    //预期滚动停止时显示在屏幕上的区域
    CGRect proposedRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    NSArray *array = [super layoutAttributesForElementsInRect:proposedRect];
    for (UICollectionViewLayoutAttributes *attribute in array) {
        CGFloat itemCenterX = attribute.center.x;
        if (ABS(itemCenterX - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemCenterX - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    NSArray *attributes =  [[NSArray alloc]initWithArray:array copyItems:YES];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        //只处理可视区域内的item
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            //可视区域中心点与item中心点距离
            CGFloat distance = CGRectGetMidX(self.collectionView.bounds) - attribute.center.x;
            CGFloat normalizedDistance = distance / (self.itemSize.width + self.minimumLineSpacing);
            if (ABS(distance) <= (self.itemSize.width + self.minimumLineSpacing)) {
                //当可视区域中心点和item中心点距离为0时达到最大放大倍数1.3
                //距离在0~self.itemSize.width + self.minimumLineSpacing之间时放大倍数在1.3~1
                CGFloat zoom = 1 + SCALE * (1 - ABS(normalizedDistance));
                attribute.transform3D = CATransform3DMakeScale(zoom, zoom, 1);
                attribute.zIndex = 1.0;
            }
        }
    }
    return attributes;
}

//返回YES，这样当边界改变(滑动)的时候，-invalidateLayout会自动被发送，才能让layout得到刷新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds{
    return YES;
}

@end

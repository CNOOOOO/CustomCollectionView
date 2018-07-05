//
//  CircleLayout.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/20.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "CircleLayout.h"
#define ITEM_SIZE 80

@implementation CircleLayout

- (void)prepareLayout {
    [super prepareLayout];
    CGSize size = self.collectionView.frame.size;
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    _center = CGPointMake(size.width / 2.0, size.height / 2.0);
    _radius = MIN(size.width, size.height) / 2.8;
}

- (CGSize)collectionViewContentSize {
    return self.collectionView.frame.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //设置attributes的属性
    attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
    attributes.center = CGPointMake(_center.x + _radius * sinf(2 * M_PI * indexPath.item /_cellCount), _center.y - _radius * cosf(2 * M_PI * indexPath.item / _cellCount));
    return attributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    for (int i = 0; i < self.cellCount; i++) {
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    return attributes;
}

/*插入前，cell在圆心位置，全透明*/
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForInsertedItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.center = CGPointMake(_center.x, _center.y);
    attributes.alpha = 0;
    return attributes;
}

/*删除时，cell在圆心位置，全透明，且只有原来的1/10大*/
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDeletedItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.center = CGPointMake(_center.x, _center.y);
    attributes.alpha = 0;
    attributes.transform3D = CATransform3DMakeScale(1/10.0,1/10.0, 1);
    return attributes;
}

@end

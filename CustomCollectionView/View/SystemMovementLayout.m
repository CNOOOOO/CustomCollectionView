//
//  SystemMovementLayout.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/14.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "SystemMovementLayout.h"

@interface SystemMovementLayout ()

@property (nonatomic, strong) NSMutableArray *cellsAttributes;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, strong) NSMutableArray *animationIndexPaths;//需要添加动画的indexpath

@end

@implementation SystemMovementLayout

- (NSMutableArray *)cellsAttributes {
    if (!_cellsAttributes) {
        _cellsAttributes = [NSMutableArray array];
    }
    return _cellsAttributes;
}

- (NSMutableArray *)animationIndexPaths {
    if (!_animationIndexPaths) {
        _animationIndexPaths = [NSMutableArray array];
    }
    return _animationIndexPaths;
}

- (instancetype)init {
    if (self = [super init]) {
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        self.columnCount = 4;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    self.maxY = 0;
    [self.cellsAttributes removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int item=0; item < count; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
        CGFloat height = 30;
        CGFloat originX = self.sectionInset.left + (item % 4) * (width + self.columnMargin);
        CGFloat originY = self.sectionInset.top + (height + self.rowMargin) * (item / self.columnCount);
        self.maxY = originY + height + self.sectionInset.bottom;
        attribute.frame = CGRectMake(originX, originY, width, height);
        [self.cellsAttributes addObject:attribute];
    }
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, self.maxY);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    [self.cellsAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [attributes addObject:attribute];
        }
    }];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = self.cellsAttributes[indexPath.item];
    return attribute;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

//告知布局对象发生了什么改变(插入、移动还是删除)
//- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
//    [super prepareForCollectionViewUpdates:updateItems];
//    NSMutableArray *indexPaths = [NSMutableArray array];
//    for (UICollectionViewUpdateItem *updateItem in updateItems) {
//        switch (updateItem.updateAction) {
//            case UICollectionUpdateActionInsert:
//                [indexPaths addObject:updateItem.indexPathAfterUpdate];
//                break;
//            case UICollectionUpdateActionDelete:
//                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
//                break;
//            case UICollectionUpdateActionMove:
////                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
////                [indexPaths addObject:updateItem.indexPathAfterUpdate];
//                break;
//            default:
//                break;
//        }
//    }
//    self.animationIndexPaths = indexPaths;
//}
//
//- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//    if ([self.animationIndexPaths containsObject:itemIndexPath]) {
//        UICollectionViewLayoutAttributes *attribute = self.cellsAttributes[itemIndexPath.item];
//        attribute.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.8, 0.8), 0);
//        attribute.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
//        attribute.alpha = 1;
//        [self.animationIndexPaths removeObject:itemIndexPath];
//        return attribute;
//    }
//    return nil;
//}
//
//- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//    if ([self.animationIndexPaths containsObject:itemIndexPath]) {
//        UICollectionViewLayoutAttributes *attribute = self.cellsAttributes[itemIndexPath.item];
//        attribute.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.8, 0.8), 0);
//        attribute.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
//        attribute.alpha = 0;
//        [self.animationIndexPaths removeObject:itemIndexPath];
//        return attribute;
//    }
//    return nil;
//}
//
//- (void)finalizeCollectionViewUpdates {
//    self.animationIndexPaths = nil;
//}

//移动相关
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<NSIndexPath *> *)targetIndexPaths withTargetPosition:(CGPoint)targetPosition previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths previousPosition:(CGPoint)previousPosition {
    UICollectionViewLayoutInvalidationContext *context = [super invalidationContextForInteractivelyMovingItems:targetIndexPaths withTargetPosition:targetPosition previousIndexPaths:previousIndexPaths previousPosition:previousPosition];
//    if ([self.delegate respondsToSelector:@selector(moveItemAtIndexPath:toIndexPath:)]) {
//        [self.delegate moveItemAtIndexPath:previousIndexPaths[0] toIndexPath:targetIndexPaths[0]];
//    }
    return context;
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:(NSArray<NSIndexPath *> *)indexPaths previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths movementCancelled:(BOOL)movementCancelled {
    UICollectionViewLayoutInvalidationContext *context = [super invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:indexPaths previousIndexPaths:previousIndexPaths movementCancelled:movementCancelled];
    if(!movementCancelled){
        
    }
    return context;
}

@end

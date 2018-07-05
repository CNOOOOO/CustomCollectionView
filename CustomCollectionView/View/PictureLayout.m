//
//  PictureLayout.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/12.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "PictureLayout.h"

@interface PictureLayout ()

@property (nonatomic, assign) NSInteger itemCount;
@property (strong, nonatomic) NSMutableDictionary *cellLayoutInfo;//保存cell的布局

@end

@implementation PictureLayout

- (instancetype)init {
    if (self = [super init]) {
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.cellLayoutInfo = [NSMutableDictionary dictionary];
        self.internalItemSpacing = -WIDTH_SCALE * 30;
        self.itemSize = CGSizeMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 64 - 40);
        self.sectionEdgeInsets = UIEdgeInsetsMake(20, 30, 20, 30);
        self.scale = 0.7;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.itemCount = [self.collectionView numberOfItemsInSection:0];
    [self.cellLayoutInfo removeAllObjects];
    for (int item=0; item<self.itemCount; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attribute.frame = CGRectMake(self.sectionEdgeInsets.left + indexPath.item * (self.itemSize.width + self.internalItemSpacing), self.sectionEdgeInsets.top, self.itemSize.width, self.itemSize.height);
        self.cellLayoutInfo[indexPath] = attribute;
    }
}

- (CGSize)collectionViewContentSize {
    CGFloat contentWidth = self.sectionEdgeInsets.left + self.sectionEdgeInsets.right + self.itemCount * self.itemSize.width + (self.itemCount - 1) * self.internalItemSpacing;
    CGFloat contentHeight = self.collectionView.frame.size.height - self.sectionEdgeInsets.top - self.sectionEdgeInsets.bottom;
    return CGSizeMake(contentWidth, contentHeight);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = self.cellLayoutInfo[indexPath];
    return attribute;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes = [NSMutableArray array];
    //添加当前屏幕可见的cell的布局
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width / 2;
    [self.cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
            CGFloat offsetX = fabs(attribute.center.x - centerX);
            CGFloat scale = 1 - (offsetX * (1 - _scale)) / ((SCREEN_WIDTH + self.itemSize.width) / 2 - self.internalItemSpacing);
            attribute.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }];
    return allAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)scrollToCurrentItemAtIndex:(NSInteger)index {
    self.currentItemIndex = index;
    [self.collectionView setContentOffset:CGPointMake(_currentItemIndex * (_internalItemSpacing + _itemSize.width), 0) animated:YES];
}

//当UICollectionView停止滚动时，用户希望停止在哪个位置上
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
//    NSInteger itemIndex = (NSInteger)(self.collectionView.contentOffset.x / (self.itemSize.width + self.internalItemSpacing));
//    CGFloat offsetX = itemIndex * (self.itemSize.width + self.internalItemSpacing);
//    CGFloat offsetX_1 = (itemIndex + 1) * (self.itemSize.width + self.internalItemSpacing);
//    if (fabs(proposedContentOffset.x - offsetX) > fabs(offsetX_1 - proposedContentOffset.x)) {
//        self.currentItemIndex = itemIndex + 1;
//        return CGPointMake(offsetX_1, 0);
//    }else {
//        self.currentItemIndex = itemIndex;
//        return CGPointMake(offsetX, 0);
//    }
    
    
    //1. 获取UICollectionView停止的时候的可视范围
    CGRect contentFrame;
    contentFrame.size = self.collectionView.frame.size;
    contentFrame.origin = proposedContentOffset;
    NSArray *array = [self layoutAttributesForElementsInRect:contentFrame];
    //2. 计算在可视范围的距离中心线最近的Item
    CGFloat minCenterX = CGFLOAT_MAX;
    CGFloat collectionViewCenterX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if(ABS(attrs.center.x - collectionViewCenterX) < ABS(minCenterX)){
            minCenterX = attrs.center.x - collectionViewCenterX;
        }
    }
    //3. 补回ContentOffset，则正好将Item居中显示
    return CGPointMake(proposedContentOffset.x + minCenterX, proposedContentOffset.y);
}

@end

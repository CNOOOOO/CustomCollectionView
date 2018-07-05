//
//  FoldLayout.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/27.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "FoldLayout.h"

@interface FoldLayout ()

@property (nonatomic, strong) NSMutableArray *attributes;

@end

@implementation FoldLayout

- (NSMutableArray *)attributes {
    if (!_attributes) {
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}

- (instancetype)init {
    if (self = [super init]) {
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return self;
}

- (void)setStandardHeight:(CGFloat)standardHeight {
    _standardHeight = standardHeight;
}

- (void)setPurposeHeight:(CGFloat)purposeHeight {
    _purposeHeight = purposeHeight;
    self.dragOffset = _purposeHeight - self.standardHeight;
}

- (void)prepareLayout {
    [super prepareLayout];
    [self.attributes removeAllObjects];
    CGRect frame = CGRectZero;
    CGFloat y = 0;
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    for (int item = 0; item < numberOfItems; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        //下一个cell都在前一个之上
        attribute.zIndex = item;
        CGFloat height = self.standardHeight;
        if (item == [self purposeItemIndex]) {
            //当前已经放大到最大的item
            CGFloat offsetY = self.standardHeight * [self heightZoomScale];
            y = self.collectionView.contentOffset.y - offsetY;
            height = self.purposeHeight;
        }else if (item == [self purposeItemIndex] + 1) {
            CGFloat maxY = y + self.standardHeight;
            height = self.standardHeight + MAX(self.dragOffset * [self heightZoomScale], 0);
            y = maxY - height;
        }
        frame = CGRectMake(0, y, CGRectGetWidth(self.collectionView.bounds), height);
        attribute.frame = frame;
        [self.attributes addObject:attribute];
        //下一个item的初始Y值
        y = CGRectGetMaxY(frame);
    }
    [self.collectionView reloadData];
}

- (CGSize)collectionViewContentSize {
    NSInteger numberOfIterm = [self.collectionView numberOfItemsInSection:0];
    CGFloat contentHeight = (numberOfIterm * self.dragOffset) + (CGRectGetHeight(self.collectionView.bounds) - self.dragOffset);
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), contentHeight);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (UICollectionViewLayoutAttributes *attributes in self.attributes) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [tempArray addObject:attributes];
        }
    }
    return tempArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.attributes[indexPath.item];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    NSInteger currentPurposeIndex = round(proposedContentOffset.y / self.dragOffset);//四舍五入
    CGFloat offSetY = currentPurposeIndex * self.dragOffset;
    return CGPointMake(0, offSetY);
}

//返回当前已经放大到最大的item的索引
- (int)purposeItemIndex {
    int index = (int)(self.collectionView.contentOffset.y / self.dragOffset);
    int numberOfIterm = (int)[self.collectionView numberOfItemsInSection:0];
    //当滑到最后一个item时继续上滑，index仍是最后一个item的index
    if (index >= numberOfIterm - 1) {
        index = numberOfIterm - 1;
    }
    return MAX(0, index);
}

//正在缩放的item的高度缩放比例
- (CGFloat)heightZoomScale {
    float index = self.collectionView.contentOffset.y / self.dragOffset;
    int numberOfIterm = (int)[self.collectionView numberOfItemsInSection:0];
    if (index >= numberOfIterm - 1) {
        index = numberOfIterm - 1;
    }
    //拿浮点数减去整数
    CGFloat scale = index - [self purposeItemIndex];
    return scale;
}

@end

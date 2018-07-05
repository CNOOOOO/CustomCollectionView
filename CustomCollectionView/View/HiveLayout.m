//
//  HiveLayout.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/8.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "HiveLayout.h"

@interface HiveLayout ()

@property (strong, nonatomic) NSMutableDictionary *cellLayoutInfo;//保存cell的布局

@end

@implementation HiveLayout

- (instancetype)init {
    if (self = [super init]) {
        self.cellLayoutInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (CGSize)collectionViewContentSize {
    //collectionView使用contentSize配置自己的scrollview，在该方法中通过设置contentSize来设置collectionView的滚动区域，当contentSize大于屏幕时collectionView就可以滑动了，方向也是由contentSize大小控制
    CGFloat width = (SCREEN_WIDTH - self.insetLeft - self.insetRight - (self.numberOfColumn - 1) * self.margin * cos(M_PI * 30.0f / 180.0f)) / ((self.numberOfColumn - 1) * 3 / 4.0 + 1);
    //高
    CGFloat height = width * cos(M_PI * 30.0f / 180.0f);
    long lines;
    long marginCount;
    if ([self.collectionView numberOfItemsInSection:0] % self.numberOfColumn > 0) {
        lines = [self.collectionView numberOfItemsInSection:0] / self.numberOfColumn + 1;
        marginCount = [self.collectionView numberOfItemsInSection:0] / self.numberOfColumn;
    }else {
        lines = [self.collectionView numberOfItemsInSection:0] / self.numberOfColumn;
        marginCount = [self.collectionView numberOfItemsInSection:0] / self.numberOfColumn - 1;
    }
    float totalHeight;
    if (self.numberOfColumn == 1) {
        totalHeight = [self.collectionView numberOfItemsInSection:0] / self.numberOfColumn * height + ([self.collectionView numberOfItemsInSection:0] / self.numberOfColumn - 1) * self.margin + self.insetTop + self.insetBottom;
    }else {
        if ([self.collectionView numberOfItemsInSection:0] % self.numberOfColumn == 1) {
            totalHeight = lines * height + marginCount * self.margin + self.insetTop + self.insetBottom;
        }else {
            totalHeight = lines * height + marginCount * self.margin + self.insetTop + self.insetBottom + self.margin / 2 + height / 2;
        }
    }
    return CGSizeMake(SCREEN_WIDTH, totalHeight);
}

- (void)prepareLayout {
    [super prepareLayout];
    //准备工作，计算布局属性
    //宽
    CGFloat width;
//    (3/4.0 * width + self.margin * cos(M_PI * 30.0f / 180.0f)) * (self.numberOfColumn - 1) + width + self.insetLeft + self.insetRight 的值等于屏幕宽度
    width = (SCREEN_WIDTH - self.insetLeft - self.insetRight - (self.numberOfColumn - 1) * self.margin * cos(M_PI * 30.0f / 180.0f)) / ((self.numberOfColumn - 1) * 3 / 4.0 + 1);
    //高
    CGFloat height = width * cos(M_PI * 30.0f / 180.0f);
    [self.cellLayoutInfo removeAllObjects];
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sectionsCount; section++) {
        //取出section有多少个row
        NSInteger rowsCount = [self.collectionView numberOfItemsInSection:section];
        //分别计算设置每个cell的布局对象
        for (NSInteger row = 0; row < rowsCount; row++) {
            NSIndexPath *indexPath =[NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            //原点Y
            float originY;
            if (self.numberOfColumn == 1) {
                originY = (indexPath.item) / self.numberOfColumn * (self.margin + height);
            }else {
                if (self.numberOfColumn % 2 > 0) {//有奇数列
                    if ((indexPath.item % self.numberOfColumn) % 2 == 1) {//偶数列
                        originY = (indexPath.item) / self.numberOfColumn * (self.margin + height);
                    }else {//奇数列
                        originY = height / 2.0 + self.margin / 2.0 + (indexPath.item / self.numberOfColumn) * (self.margin + height);
                    }
                }else {//有偶数列
                    if (indexPath.item % 2 == 1) {//偶数列
                        originY = height / 2.0 + self.margin / 2.0 + (indexPath.item / self.numberOfColumn) * (self.margin + height);
                    }else {//奇数列
                        originY = (indexPath.item) / self.numberOfColumn * (self.margin + height);
                    }
                }
            }
            attribute.frame = CGRectMake(self.insetLeft + (indexPath.item % self.numberOfColumn) * (3 / 4.0 * width + self.margin * cos(M_PI * 30.0f / 180.0f)), self.insetTop + originY, width, height);
            //保留cell的布局对象
            self.cellLayoutInfo[indexPath] = attribute;
        }
    }
}

//返回每一个item的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = self.cellLayoutInfo[indexPath];
    return attribute;
}

//返回需要重新布局的所有item属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    //返回可视区域cell的属性
    //方式一：
//    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//    if ([array count] > 0) {
//        return array;
//    }
//    NSMutableArray *attributes = [NSMutableArray array];
//    for (NSInteger i = 0 ; i < [self.collectionView numberOfItemsInSection:0 ]; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
//    }
//    return attributes;
    
    //方式二：
    NSMutableArray *allAttributes = [NSMutableArray array];
    //添加当前屏幕可见的cell的布局
    [self.cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    return allAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    //显示范围发生改变时，更新布局(如滚动时)
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        return YES;
    }
    return NO;
}

@end

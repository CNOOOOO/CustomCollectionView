//
//  WaterfallLayout.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/13.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "WaterfallLayout.h"

@interface WaterfallLayout ()

@property (nonatomic, strong) NSMutableDictionary *sectionOneMaxYDic;//存储每列的最大Y值
@property (nonatomic, strong) NSMutableDictionary *sectionTwoMaxYDic;//存储每列的最大Y值
@property (nonatomic, strong) NSMutableArray *sectionOneAttributes;//存储cell的布局属性
@property (nonatomic, strong) NSMutableArray *sectionTwoAttributes;//存储cell的布局属性
@property (nonatomic, strong) NSMutableArray *headers;//顶部视图
@property (nonatomic, strong) NSMutableArray *footers;//底部视图

@end

@implementation WaterfallLayout

- (NSMutableDictionary *)sectionOneMaxYDic {
    if (!_sectionOneMaxYDic) {
        _sectionOneMaxYDic = [NSMutableDictionary dictionary];
    }
    return _sectionOneMaxYDic;
}

- (NSMutableDictionary *)sectionTwoMaxYDic {
    if (!_sectionTwoMaxYDic) {
        _sectionTwoMaxYDic = [NSMutableDictionary dictionary];
    }
    return _sectionTwoMaxYDic;
}

- (NSMutableArray *)sectionOneAttributes {
    if (!_sectionOneAttributes) {
        _sectionOneAttributes = [NSMutableArray array];
    }
    return _sectionOneAttributes;
}

- (NSMutableArray *)sectionTwoAttributes {
    if (!_sectionTwoAttributes) {
        _sectionTwoAttributes = [NSMutableArray array];
    }
    return _sectionTwoAttributes;
}

- (NSMutableArray *)headers {
    if (!_headers) {
        _headers = [NSMutableArray array];
    }
    return _headers;
}

- (NSMutableArray *)footers {
    if (!_footers) {
        _footers = [NSMutableArray array];
    }
    return _footers;
}

- (instancetype)init {
    if (self = [super init]) {
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.columnCount = 2;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    //清空最大Y值,将collectionview的顶部偏移量做初值
    if (self.headerHeight) {
        for (int i=0; i < self.columnCount; i++) {
            NSString *column = [NSString stringWithFormat:@"%d",i];
            self.sectionOneMaxYDic[column] = @(self.sectionInset.top + self.headerHeight);
        }
    }else {
        for (int i=0; i < self.columnCount; i++) {
            NSString *column = [NSString stringWithFormat:@"%d",i];
            self.sectionOneMaxYDic[column] = @(self.sectionInset.top);
        }
    }
    [self.sectionOneAttributes removeAllObjects];
    //第一个section
    NSInteger countOne = [self.collectionView numberOfItemsInSection:0];
    for (int item=0; item < countOne; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        __block NSString *minColumn = @"0";
        [self.sectionOneMaxYDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj floatValue] < [self.sectionOneMaxYDic[minColumn] floatValue]) {
                minColumn = key;
            }
        }];
        //计算item的宽高
        CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - self.columnMargin * (self.columnCount - 1)) / self.columnCount;
        CGFloat height = [self.delegate waterfallLayout:self heightForItem:width atIndexPath:indexPath];
        //计算每个item的原点
        CGFloat originX = self.sectionInset.left + (width + self.columnMargin) * [minColumn floatValue];//下一个总是接在Y最小的那一列
        CGFloat originY;
        //为了使顶部的item不加上self.rowMargin，做如下判断
        if ([self.sectionOneMaxYDic[minColumn] floatValue] == self.sectionInset.top || [self.sectionOneMaxYDic[minColumn] floatValue] == self.sectionInset.top + self.headerHeight) {
            originY = [self.sectionOneMaxYDic[minColumn] floatValue];
        }else {
            originY = [self.sectionOneMaxYDic[minColumn] floatValue] + self.rowMargin;
        }
        self.sectionOneMaxYDic[minColumn] = @(originY + height);
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attribute.frame = CGRectMake(originX, originY, width, height);
        [self.sectionOneAttributes addObject:attribute];
    }
    
    //第二个section
    //获取section0最大Y值对应的key
    __block NSString *maxColumn = @"0";
    [self.sectionOneMaxYDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj floatValue] > [self.sectionOneMaxYDic[maxColumn] floatValue]) {
            maxColumn = key;
        }
    }];
    //section1接在section0的后面,所以Y初始值为section0的最大Y值
    for (int i=0; i < 2; i++) {
        NSString *column = [NSString stringWithFormat:@"%d",i];
        self.sectionTwoMaxYDic[column] = @([self.sectionOneMaxYDic[maxColumn] floatValue] + self.headerHeight + self.footerHeight);
    }
    [self.sectionTwoAttributes removeAllObjects];
    
    NSInteger countTwo = [self.collectionView numberOfItemsInSection:1];
    for (int i=0; i < countTwo; i++) {
        __block NSString *minColumn = @"0";
        [self.sectionTwoMaxYDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj floatValue] < [self.sectionTwoMaxYDic[minColumn] floatValue]) {
                minColumn = key;
            }
        }];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:1];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - self.columnMargin) / 2.0;
        CGFloat height;
        if (i % 6 == 0 || i % 6 == 4) {
            height = 120;
        }else {
            //如果直接用self.rowMargin做两个小的item的间隔
//            height = (120 - self.rowMargin) / 2.0;
            //自定义两个小的item的间隔
            height = (120 - 3) / 2.0;
        }
        CGFloat originX = self.sectionInset.left + (width + self.columnMargin) * [minColumn floatValue];
        CGFloat originY;
        //自定义两个小的item的间隔
        if (i % 3 == 2) {
            originY = [self.sectionTwoMaxYDic[minColumn] floatValue] + 3;
        }else {
            originY = [self.sectionTwoMaxYDic[minColumn] floatValue] + self.rowMargin;
        }
        //如果直接用self.rowMargin做两个小的item的间隔
//        originY = [self.sectionTwoMaxYDic[minColumn] floatValue] + self.rowMargin;
        self.sectionTwoMaxYDic[minColumn] = @(originY + height);
        attribute.frame = CGRectMake(originX, originY, width, height);
        [self.sectionTwoAttributes addObject:attribute];
    }
    
    //设置header、footer布局
    [self.headers removeAllObjects];
    [self.footers removeAllObjects];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (int section=0; section < sectionCount; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        //header
        if (self.headerHeight && [self.collectionView.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
            if (section == 0) {
                attribute.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, self.headerHeight);
            }else {
                attribute.frame = CGRectMake(0, [self.sectionOneMaxYDic[maxColumn] floatValue] + self.footerHeight, self.collectionView.frame.size.width, self.headerHeight);
            }
            [self.headers addObject:attribute];
        }
        //footer
        if (self.footerHeight && [self.collectionView.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
            if (section == 0) {
                attribute.frame = CGRectMake(0, [self.sectionOneMaxYDic[maxColumn] floatValue], self.collectionView.frame.size.width, self.footerHeight);
            }else {
                __block NSString *sectionTwoMaxColumn = @"0";
                [self.sectionTwoMaxYDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([obj floatValue] > [self.sectionTwoMaxYDic[sectionTwoMaxColumn] floatValue]) {
                        sectionTwoMaxColumn = key;
                    }
                }];
                attribute.frame = CGRectMake(0, [self.sectionTwoMaxYDic[sectionTwoMaxColumn] floatValue], self.collectionView.frame.size.width, self.footerHeight);
            }
            [self.footers addObject:attribute];
        }
    }
}

- (CGSize)collectionViewContentSize {
    __block NSString *sectionTwoMaxColumn = @"0";
    [self.sectionTwoMaxYDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj floatValue] > [self.sectionTwoMaxYDic[sectionTwoMaxColumn] floatValue]) {
            sectionTwoMaxColumn = key;
        }
    }];
    return CGSizeMake(self.collectionView.frame.size.width,[self.sectionTwoMaxYDic[sectionTwoMaxColumn] floatValue] + self.sectionInset.bottom + self.footerHeight);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UICollectionViewLayoutAttributes *attribute = self.sectionOneAttributes[indexPath.item];
        return attribute;
    }else {
        UICollectionViewLayoutAttributes *attribute = self.sectionTwoAttributes[indexPath.item];
        return attribute;
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute;
    if (elementKind == UICollectionElementKindSectionHeader) {
        attribute = self.headers[indexPath.section];
    }
    if (elementKind == UICollectionElementKindSectionFooter) {
        attribute = self.footers[indexPath.section];
    }
    return attribute;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes = [NSMutableArray array];
    //header
    [self.headers enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    //footer
    [self.footers enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    //添加当前屏幕可见的cell的布局
    [self.sectionOneAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    [self.sectionTwoAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    return allAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end

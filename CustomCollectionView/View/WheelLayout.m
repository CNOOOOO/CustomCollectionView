//
//  WheelLayout.m
//  CustomCollectionView
//
//  Created by Mac2 on 2018/7/3.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "WheelLayout.h"
#import "WheelCollectionViewLayoutAttributes.h"

@interface WheelLayout ()

@property (nonatomic, assign) CGFloat anglePerItem;//每一个item的旋转角
@property (nonatomic, strong) NSMutableArray *attributes;

@end

@implementation WheelLayout

- (NSMutableArray *)attributes {
    if (!_attributes) {
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}

- (instancetype)init {
    if (self = [super init]) {
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.radius = 800.0;
        self.itemSize = CGSizeMake(SCREEN_WIDTH, 300);
        self.anglePerItem = atan(self.itemSize.width / self.radius);
    }
    return self;
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
}

- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
}

- (void)prepareLayout {
    [super prepareLayout];
    [self.attributes removeAllObjects];
    NSInteger numberOfItem = [self.collectionView numberOfItemsInSection:0];
    if (numberOfItem == 0) {
        return;
    }
    //获取总的旋转角
    CGFloat angleAtExtreme = (numberOfItem - 1) * self.anglePerItem;
    //随着collectionview的旋转，第0个item初始的旋转角,self.collectionView.contentSize.width - self.collectionView.bounds.size.width为X轴最大偏移量
    CGFloat angle = -angleAtExtreme * self.collectionView.contentOffset.x / (self.collectionView.contentSize.width - self.collectionView.bounds.size.width);
    //当前屏幕X轴中心点的坐标
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2.0;
    //锚点Y的位置(锚点(0.5, 0.5)位置刚好在宽高的中心点上)
    CGFloat anchorPointY = (self.itemSize.height / 2 + self.radius) / self.itemSize.height;
    for (int i=0; i < numberOfItem; i++) {
        WheelCollectionViewLayoutAttributes *attribute = [WheelCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        attribute.size = self.itemSize;
        attribute.anchorPoint = CGPointMake(0.5, anchorPointY);
        attribute.center = CGPointMake(centerX, self.itemSize.height/2.0);
        attribute.angle = angle + self.anglePerItem * i;
        attribute.transform = CGAffineTransformMakeRotation(attribute.angle);
        attribute.zIndex = (int)-i * 1000;
        [self.attributes addObject:attribute];
    }
}

- (CGSize)collectionViewContentSize {
    NSInteger numberOfItem = [self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(numberOfItem * self.itemSize.width, self.collectionView.bounds.size.height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.attributes[indexPath.item];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    //最终停下来的偏移量
    CGPoint finalContentOffset = proposedContentOffset;
    //最大旋转
    CGFloat angleAtExtreme = ([self.collectionView numberOfItemsInSection:0] - 1) * self.anglePerItem;
    //每1距离的偏移对应旋转的角度
    CGFloat factor = -angleAtExtreme / (self.collectionView.contentSize.width - CGRectGetWidth(self.collectionView.bounds));
    //停下来时，旋转的角度
    CGFloat proposedAngle = self.collectionView.contentOffset.x * factor;
    CGFloat ratio = proposedAngle / self.anglePerItem;
    finalContentOffset.x = round(ratio) * self.anglePerItem / factor;
    return finalContentOffset;
}

@end

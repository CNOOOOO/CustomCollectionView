//
//  DecliningLayout.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/29.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "DecliningLayout.h"

@implementation DecliningLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    NSArray *attributes = [[NSArray alloc] initWithArray:array copyItems:YES];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        attribute.transform = CGAffineTransformMakeRotation(-15 * M_PI / 180.0);
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end

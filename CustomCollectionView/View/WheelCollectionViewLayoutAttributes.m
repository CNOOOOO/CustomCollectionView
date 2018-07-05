//
//  WheelCollectionViewLayoutAttributes.m
//  CustomCollectionView
//
//  Created by Mac2 on 2018/7/3.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "WheelCollectionViewLayoutAttributes.h"

@implementation WheelCollectionViewLayoutAttributes

- (instancetype)init{
    self = [super init];
    if (self) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.angle = 0;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    WheelCollectionViewLayoutAttributes *attribute = [super copyWithZone:zone];
    attribute.anchorPoint = self.anchorPoint;
    attribute.angle = self.angle;
    return attribute;
}

@end

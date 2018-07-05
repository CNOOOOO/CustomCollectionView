//
//  WheelCell.m
//  CustomCollectionView
//
//  Created by Mac2 on 2018/7/3.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "WheelCell.h"
#import "WheelCollectionViewLayoutAttributes.h"

@interface WheelCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WheelCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.cornerRadius = 6;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.imageView.layer.borderWidth = 1;
        //抗锯齿
        self.imageView.layer.allowsEdgeAntialiasing = YES;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:_imageName];
}

//对于自定义的属性anchorPoint，必须手动实现这个方法
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    WheelCollectionViewLayoutAttributes *attribute = (WheelCollectionViewLayoutAttributes *)layoutAttributes;
    self.layer.anchorPoint = attribute.anchorPoint;
    CGFloat radius = (attribute.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds);
    self.center = CGPointMake(self.center.x, radius + self.center.y);
}

@end

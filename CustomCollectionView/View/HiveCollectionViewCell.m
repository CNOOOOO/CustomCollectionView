//
//  HiveCollectionViewCell.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/8.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "HiveCollectionViewCell.h"

@implementation HiveCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 6;
        self.imageView.image = [UIImage imageNamed:@"apple"];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //生成六边形
    CGFloat width = self.contentView.bounds.size.width;
    CGFloat longSide = width * 0.5 * cosf(M_PI * 30 / 180);
    CGFloat shortSide = width * 0.5 *sinf(M_PI * 30 /180);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, longSide)];
    [path addLineToPoint:CGPointMake(shortSide, 0)];
    [path addLineToPoint:CGPointMake(shortSide + width * 0.5, 0)];
    [path addLineToPoint:CGPointMake(width, longSide)];
    [path addLineToPoint:CGPointMake(shortSide + width * 0.5, longSide * 2)];
    [path addLineToPoint:CGPointMake(shortSide, longSide * 2)];
    [path closePath];
    
    // step 2: 根据路径生成蒙板
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [path CGPath];
    
    // step 3: 给cell添加模版
    self.layer.mask = maskLayer;
    
    self.backgroundColor = [UIColor clearColor];
    self.imageView.frame = self.contentView.frame;
    self.titleLabel.frame = self.contentView.frame;
}

@end

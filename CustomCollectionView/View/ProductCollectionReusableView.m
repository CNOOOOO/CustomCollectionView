//
//  ProductCollectionReusableView.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/14.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "ProductCollectionReusableView.h"

@implementation ProductCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        
        self.leftLine = [[UIView alloc] init];
        self.leftLine.backgroundColor = [UIColor grayColor];
        [self addSubview:self.leftLine];
        [self.leftLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.titleLabel.mas_left).offset(-15);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(0.5);
        }];
        
        self.rightLine = [[UIView alloc] init];
        self.rightLine.backgroundColor = [UIColor grayColor];
        [self addSubview:self.rightLine];
        [self.rightLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(15);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(0.5);
        }];
        
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

@end

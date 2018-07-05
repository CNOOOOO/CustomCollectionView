//
//  ShopCollectionViewCell.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/13.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "ShopCollectionViewCell.h"

@implementation ShopCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3;
    self.imageView.image = [UIImage imageNamed:@"nike"];
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageView];
    
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

@end

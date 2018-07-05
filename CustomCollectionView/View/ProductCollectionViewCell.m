//
//  ProductCollectionViewCell.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/13.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "ProductCollectionViewCell.h"

@implementation ProductCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 6;
    self.imageView.image = [UIImage imageNamed:@"cloth"];
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageView];
    
    self.introLabel = [[UILabel alloc] init];
    self.introLabel.text = @"京东6.18狂欢节，年中大促，买一送十";
    self.introLabel.textColor = [UIColor blackColor];
    self.introLabel.numberOfLines = 2;
    self.introLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.introLabel];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.text = @"¥ 100";
    self.priceLabel.textColor = [UIColor redColor];
    self.priceLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.priceLabel];
    
    self.salesVolumeLabel = [[UILabel alloc] init];
    self.salesVolumeLabel.text = @"月销量：30";
    self.salesVolumeLabel.textColor = [UIColor blackColor];
    self.salesVolumeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.salesVolumeLabel];
    
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    
    [self.introLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(13);
    }];
    
    [self.salesVolumeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(12);
    }];
}

@end

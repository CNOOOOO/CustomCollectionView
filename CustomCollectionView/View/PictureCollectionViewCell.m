//
//  PictureCollectionViewCell.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/12.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "PictureCollectionViewCell.h"

@implementation PictureCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 20;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

@end

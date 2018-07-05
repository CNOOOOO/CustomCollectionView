//
//  CircleCollectionViewCell.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/20.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "CircleCollectionViewCell.h"

@interface CircleCollectionViewCell()

@property (nonatomic,strong) UILabel *tipLabel;

@end

@implementation CircleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.tipLabel];
        self.tipLabel.frame = self.contentView.bounds;
        self.contentView.layer.cornerRadius = 80/2.0;
    }
    return self;
}

- (void)setTip:(NSString *)tip{
    self.tipLabel.text = tip;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = [UIFont boldSystemFontOfSize:25];
        _tipLabel.textColor = [UIColor blackColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

@end

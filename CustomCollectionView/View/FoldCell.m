//
//  FoldCell.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/28.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "FoldCell.h"

@interface FoldCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeAndRoomLabel;
@property (nonatomic, strong) UILabel *speakerLabel;

@end

@implementation FoldCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.coverView = [[UIView alloc] init];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.75;
    [self.contentView addSubview:self.coverView];
    [self.coverView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:38];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    self.timeAndRoomLabel = [[UILabel alloc] init];
    self.timeAndRoomLabel.font = [UIFont systemFontOfSize:17];
    self.timeAndRoomLabel.textAlignment = NSTextAlignmentCenter;
    self.timeAndRoomLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.timeAndRoomLabel];
    [self.timeAndRoomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    
    self.speakerLabel = [[UILabel alloc] init];
    self.speakerLabel.font = [UIFont systemFontOfSize:17];
    self.speakerLabel.textColor = [UIColor whiteColor];
    self.speakerLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.speakerLabel];
    [self.speakerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.timeAndRoomLabel.mas_bottom);
        make.height.mas_equalTo(20);
    }];
}

- (void)setModel:(FoldModel *)model {
    self.imageView.image = [UIImage imageNamed:model.Background];
    self.titleLabel.text = model.Title;
    self.timeAndRoomLabel.text = [NSString stringWithFormat:@"%@·%@",model.Time, model.Room];
    self.speakerLabel.text = model.Speaker;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    CGFloat standardHeight = 100.0;
    CGFloat purposeHeight = 280.0;
    /*根据移动距离改变CoverView透明度*/
    CGFloat factor = 1 - (purposeHeight - CGRectGetHeight(layoutAttributes.frame))/(purposeHeight - standardHeight);
    CGFloat minAlpha = 0.2;
    CGFloat maxAlpha = 0.75;
    CGFloat currentAlpha = maxAlpha - (maxAlpha - minAlpha) * factor;
    self.coverView.alpha = currentAlpha;
    
    /*改变字体大小*/
    CGFloat titleScale = MAX(0.5, factor);
    self.titleLabel.transform = CGAffineTransformMakeScale(titleScale, titleScale);
    
    /*设置detailLabel的透明度*/
    self.timeAndRoomLabel.alpha = factor;
    self.speakerLabel.alpha = factor;
}

@end

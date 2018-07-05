//
//  DecliningCell.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/29.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "DecliningCell.h"

@interface DecliningCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeAndRoomLabel;
@property (nonatomic, strong) UILabel *speakerLabel;

@end

@implementation DecliningCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell {
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.clipsToBounds = YES;
    //图片抗锯齿
    self.containerView.layer.allowsEdgeAntialiasing = YES;
    [self.contentView addSubview:self.containerView];
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(-40);
        make.right.mas_equalTo(40);
    }];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.containerView addSubview:self.imageView];
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.right.mas_equalTo(0);
    }];
    
    self.coverView = [[UIView alloc] init];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.3;
    [self.containerView addSubview:self.coverView];
    [self.coverView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:25];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    self.speakerLabel = [[UILabel alloc] init];
    self.speakerLabel.font = [UIFont systemFontOfSize:17];
    self.speakerLabel.textColor = [UIColor whiteColor];
    self.speakerLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.speakerLabel];
    [self.speakerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.timeAndRoomLabel = [[UILabel alloc] init];
    self.timeAndRoomLabel.font = [UIFont systemFontOfSize:17];
    self.timeAndRoomLabel.textAlignment = NSTextAlignmentCenter;
    self.timeAndRoomLabel.textColor = [UIColor whiteColor];
    [self.containerView addSubview:self.timeAndRoomLabel];
    [self.timeAndRoomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.speakerLabel.mas_top);
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
    /*让imageView不跟随cell进行旋转*/
    CGFloat angle = 15 * M_PI / 180.0;
    self.imageView.transform = CGAffineTransformMakeRotation(angle);
}

- (void)resetImageViewCenterYWithCollectionViewBounds:(CGRect)collectionViewBounds {
    //collectionview中心点
    CGPoint collectionViewCenter = CGPointMake(CGRectGetMidX(collectionViewBounds), CGRectGetMidY(collectionViewBounds));
    //item中心点
    CGPoint itemCenter = self.center;
    //item中心点和collectionview中心点之间的偏移量
    CGPoint offsetPoint = CGPointMake(collectionViewCenter.x - itemCenter.x, collectionViewCenter.y - itemCenter.y);
    //可视情况下item和collectionview两中心点之间最大的偏移量
    CGFloat maxOffsetY = collectionViewBounds.size.height / 2.0 + self.bounds.size.height / 2.0;
    //偏移因子
    CGFloat factor = 40.0 / maxOffsetY;
    //偏移imageView
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView.mas_centerY).offset(offsetPoint.y * factor);
    }];
}

@end

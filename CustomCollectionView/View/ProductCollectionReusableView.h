//
//  ProductCollectionReusableView.h
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/14.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UIView *leftLine;//左横线
@property (nonatomic, strong) UIView *rightLine;//右横线
@property (nonatomic, strong) UIImageView *imageView;

@end

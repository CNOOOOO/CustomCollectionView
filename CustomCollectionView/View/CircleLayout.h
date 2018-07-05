//
//  CircleLayout.h
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/20.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleLayout : UICollectionViewLayout

@property (nonatomic, assign) CGPoint center;//中心点
@property (nonatomic, assign) CGFloat radius;//半径
@property (nonatomic, assign) NSInteger cellCount;//cell数量

@end

//
//  HiveLayout.h
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/8.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HiveLayout : UICollectionViewLayout

@property (nonatomic, assign) int numberOfColumn;//多少列
@property (nonatomic, assign) NSInteger margin;//六边形间距
@property (nonatomic, assign) NSInteger insetLeft;//左间距
@property (nonatomic, assign) NSInteger insetRight;//右间距
@property (nonatomic, assign) NSInteger insetTop;//上间距
@property (nonatomic, assign) NSInteger insetBottom;//下间距

@end

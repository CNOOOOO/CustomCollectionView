//
//  FoldLayout.h
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/27.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoldLayout : UICollectionViewLayout

//从标准到放大需要拖拽的距离
@property (nonatomic, assign) CGFloat dragOffset;
//默认高度
@property (nonatomic, assign) CGFloat standardHeight;
//滚动后的最大高度
@property (nonatomic, assign) CGFloat purposeHeight;

@end

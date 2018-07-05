//
//  DecliningCell.h
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/29.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoldModel.h"

@interface DecliningCell : UICollectionViewCell

@property (nonatomic, strong) FoldModel *model;

//滑动时让image反向偏移
- (void)resetImageViewCenterYWithCollectionViewBounds:(CGRect)collectionViewBounds;

@end

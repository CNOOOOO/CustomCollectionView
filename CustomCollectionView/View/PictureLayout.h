//
//  PictureLayout.h
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/12.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureLayout : UICollectionViewLayout

@property(nonatomic, assign) CGFloat internalItemSpacing;
@property(nonatomic, assign) CGSize itemSize;
@property(nonatomic, assign) UIEdgeInsets sectionEdgeInsets;
@property(nonatomic, assign) CGFloat scale;
@property(nonatomic, assign) NSInteger currentItemIndex;
- (void)scrollToCurrentItemAtIndex:(NSInteger)index;

@end

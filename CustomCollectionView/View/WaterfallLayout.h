//
//  WaterfallLayout.h
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/13.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterfallLayout;
@protocol WaterfallLayoutDelegate <NSObject>

//为每个item设置高度
- (CGFloat)waterfallLayout:(WaterfallLayout *)layout heightForItem:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath;

@end

@interface WaterfallLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat headerHeight;//头部视图高度
@property (nonatomic, assign) CGFloat footerHeight;//底部视图高度
@property (nonatomic, assign) CGFloat columnMargin;//列间距
@property (nonatomic, assign) CGFloat rowMargin;//行间距
@property (nonatomic, assign) UIEdgeInsets sectionInset;//设置collectionView边缘的间距
@property (nonatomic, assign) NSInteger columnCount;//每一行排列的个数
@property (nonatomic, weak) id <WaterfallLayoutDelegate> delegate;

@end

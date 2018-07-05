//
//  CNDragCellCollectionView.h
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/15.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CNDragCellCollectionView;
@protocol CNDragCellCollectionViewDelegate <UICollectionViewDelegate>

@required
/** 数据源更新时调用 */
- (void)dragCellCollectionView:(CNDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray;
@optional
/** 排除不需要做操作(移动、晃动)的cell的indexpath */
- (NSArray<NSIndexPath *> *)excludeIndexPathsWhenMoveDragCellCollectionView:(CNDragCellCollectionView *)collectionView;
/** cell将要开始移动的时候调用 */
- (void)dragCellCollectionView:(CNDragCellCollectionView *)collectionView cellWillBeginMoveAtIndexPath:(NSIndexPath *)indexPath;
/** cell正在移动*/
- (void)dragCellCollectionViewCellIsMoving:(CNDragCellCollectionView *)collectionView;
/** cell结束移动*/
- (void)dragCellCollectionViewCellEndMoving:(CNDragCellCollectionView *)collectionView;
/** 移动成功*/
- (void)dragCellCollectionView:(CNDragCellCollectionView *)collectionView moveCellFromIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

@end

@protocol CNDragCellCollectionViewDataSource <UICollectionViewDataSource>

@required
/**返回collectionview的所有数据，需根据数据进行移动后的重排*/
- (NSArray *)dataArrayOfCollectionView:(CNDragCellCollectionView *)collectionView;

@end

@interface CNDragCellCollectionView : UICollectionView

@property (nonatomic, weak) id<CNDragCellCollectionViewDelegate> delegate;
@property (nonatomic, weak) id<CNDragCellCollectionViewDataSource> dataSource;
/** 长按的时长，默认1秒，为0时一按下去就可以拖拽 */
@property (nonatomic, assign) CGFloat minimumPressDuration;
/** 是否开启拖动到边缘滚动CollectionView的功能，默认YES */
@property (nonatomic, assign) BOOL edgeScrollEable;
/** 是否开启拖动的时候所有cell抖动的效果，默认YES */
@property (nonatomic, assign) BOOL shakeWhenMoving;
/** 抖动的等级(1.0f~10.0f)，默认4 */
@property (nonatomic, assign) CGFloat shakeLevel;

@end

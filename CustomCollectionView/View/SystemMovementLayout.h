//
//  SystemMovementLayout.h
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/14.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SystemMovementLayout;
//@protocol SystemMovementLayoutDelegate <NSObject>
//
////移动
//- (void)moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
//
//@end

@interface SystemMovementLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat columnMargin;//列间距
@property (nonatomic, assign) CGFloat rowMargin;//行间距
@property (nonatomic, assign) UIEdgeInsets sectionInset;//设置collectionView边缘的间距
@property (nonatomic, assign) NSInteger columnCount;//每一行排列的个数
//@property (nonatomic, weak) id <SystemMovementLayoutDelegate> delegate;

@end

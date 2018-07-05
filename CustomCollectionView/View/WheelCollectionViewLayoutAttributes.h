//
//  WheelCollectionViewLayoutAttributes.h
//  CustomCollectionView
//
//  Created by Mac2 on 2018/7/3.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WheelCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

/**锚点的位置 */
@property (nonatomic,assign) CGPoint anchorPoint;
/*item旋转的角度*/
@property (nonatomic,assign) CGFloat angle;

@end

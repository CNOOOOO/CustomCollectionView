//
//  CNDragCellCollectionView.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/15.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "CNDragCellCollectionView.h"

#define angelToRandian(x)  ((x) / 180.0 * M_PI)

typedef NS_ENUM(NSUInteger, CNDragCellCollectionViewScrollDirection) {
    CNDragCellCollectionViewScrollDirectionNone = 0,
    CNDragCellCollectionViewScrollDirectionUp,
    CNDragCellCollectionViewScrollDirectionLeft,
    CNDragCellCollectionViewScrollDirectionDown,
    CNDragCellCollectionViewScrollDirectionRight
};

@interface CNDragCellCollectionView ()

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;//长按手势
@property (nonatomic, strong) NSIndexPath *sourceCellIndexPath;//被移动cell的初始indexpath
@property (nonatomic, weak)   UICollectionViewCell *sourceCell;//被移动的cell
@property (nonatomic, assign) CGPoint sourceCellCenter;//被移动cell的初始中心点
@property (nonatomic, strong) NSIndexPath *moveIndexPath;//最终位置
@property (nonatomic, weak)   UIView *tempMoveCell;//临时创建的跟随手指移动的cell
@property (nonatomic, strong) CADisplayLink *edgeTimer;//
@property (nonatomic, assign) CGPoint lastPoint;//起始位置
@property (nonatomic, assign) CNDragCellCollectionViewScrollDirection scrollDirection;//collectionview的滚动方向
@property (nonatomic, assign) BOOL observing;//是否在观察
@property (nonatomic, assign) BOOL isPanning;//是否正在拖动

@end

@implementation CNDragCellCollectionView

@dynamic delegate;
@dynamic dataSource;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self prepareForCollectionView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self prepareForCollectionView];
    }
    return self;
}

- (void)setMinimumPressDuration:(CGFloat)minimumPressDuration {
    _minimumPressDuration = minimumPressDuration;
}

- (void)setEdgeScrollEable:(BOOL)edgeScrollEable {
    _edgeScrollEable = edgeScrollEable;
}

- (void)setShakeWhenMoving:(BOOL)shakeWhenMoving {
    _shakeWhenMoving = shakeWhenMoving;
}

- (void)setShakeLevel:(CGFloat)shakeLevel {
    _shakeLevel = shakeLevel;
}

- (void)prepareForCollectionView {
    //设置默认属性
    _minimumPressDuration = 1;
    _edgeScrollEable = YES;
    _shakeWhenMoving = YES;
    _shakeLevel = 4.0;
    //添加长按手势
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    self.longPressGesture.minimumPressDuration = self.minimumPressDuration;
    [self addGestureRecognizer:self.longPressGesture];
    //添加偏移量观察
    [self addContentOffsetObserver];
}

/**
 重写hitTest事件，判断是否应该响应自己的滑动手势，还是系统的滑动手势
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if ([self indexPathForItemAtPoint:point]) {
        _longPressGesture.enabled = YES;
    }else {
        _longPressGesture.enabled = NO;
    }
    return [super hitTest:point withEvent:event];
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)longPressGesture {
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {//开始
        [self longPressBegan:longPressGesture];
    }
    if (longPressGesture.state == UIGestureRecognizerStateChanged) {//改变
        [self longPressChanged:longPressGesture];
    }
    if (longPressGesture.state == UIGestureRecognizerStateCancelled ||
        longPressGesture.state == UIGestureRecognizerStateEnded){//取消或结束
        [self longPressCancelledOrEnded:longPressGesture];
    }
}

- (void)longPressBegan:(UILongPressGestureRecognizer *)longPressGesture {
    //获取手指按下的cell的indexpath
    self.sourceCellIndexPath = [self indexPathForItemAtPoint:[longPressGesture locationOfTouch:0 inView:longPressGesture.view]];
    //判断当前点击的cell的indexpath有没有被排除
    if ([self indexPathIsExcluded:self.sourceCellIndexPath]) {
        return;
    }
    _isPanning = YES;
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:self.sourceCellIndexPath];
    UIImage *snap;
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, 1.0f, 0);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIView *tempMoveCell = [UIView new];
    tempMoveCell.layer.contents = (__bridge id)snap.CGImage;
    self.tempMoveCell = tempMoveCell;
    self.tempMoveCell.frame = cell.frame;
    cell.hidden = YES;
    self.sourceCell = cell;
    self.sourceCellCenter = cell.center;
    [self addSubview:self.tempMoveCell];
    //开启边缘滚动定时器
    [self setUpEdgeTimer];
    //开启抖动
    [self shakeAllCells];
    self.lastPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
    if ([self.delegate respondsToSelector:@selector(dragCellCollectionView:cellWillBeginMoveAtIndexPath:)]) {
        [self.delegate dragCellCollectionView:self cellWillBeginMoveAtIndexPath:self.sourceCellIndexPath];
    }
}

- (void)longPressChanged:(UILongPressGestureRecognizer *)longPressGesture {
    if ([self.delegate respondsToSelector:@selector(dragCellCollectionViewCellIsMoving:)]) {
        [self.delegate dragCellCollectionViewCellIsMoving:self];
    }
    CGFloat tranX = [longPressGesture locationOfTouch:0 inView:longPressGesture.view].x - _lastPoint.x;
    CGFloat tranY = [longPressGesture locationOfTouch:0 inView:longPressGesture.view].y - _lastPoint.y;
    _tempMoveCell.center = CGPointApplyAffineTransform(_tempMoveCell.center, CGAffineTransformMakeTranslation(tranX, tranY));
    _lastPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
    [self moveCell];
}

- (void)longPressCancelledOrEnded:(UILongPressGestureRecognizer *)longPressGesture {
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:_sourceCellIndexPath];
    self.userInteractionEnabled = NO;
    _isPanning = NO;
    [self stopEdgeTimer];
    //通知代理
    if ([self.delegate respondsToSelector:@selector(dragCellCollectionViewCellEndMoving:)]) {
        [self.delegate dragCellCollectionViewCellEndMoving:self];
    }
    [UIView animateWithDuration:0.25 animations:^{
        _tempMoveCell.center = _sourceCellCenter;
    } completion:^(BOOL finished) {
        [self stopShakeAllCells];
        [_tempMoveCell removeFromSuperview];
        cell.hidden = NO;
        _sourceCell.hidden = NO;
        self.userInteractionEnabled = YES;
        _sourceCellIndexPath = nil;
    }];
}

//判断当前indexpath是否被排除
- (BOOL)indexPathIsExcluded:(NSIndexPath *)indexPath{
    if (!indexPath || ![self.delegate respondsToSelector:@selector(excludeIndexPathsWhenMoveDragCellCollectionView:)]) {
        return NO;
    }
    NSArray<NSIndexPath *> *excludeIndexPaths = [self.delegate excludeIndexPathsWhenMoveDragCellCollectionView:self];
    __block BOOL flag = NO;
    [excludeIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.item == indexPath.item && obj.section == indexPath.section) {
            flag = YES;
            *stop = YES;
        }
    }];
    return flag;
}

//开启边缘滚动定时器
- (void)setUpEdgeTimer {
    if (!_edgeTimer && _edgeScrollEable) {
        _edgeTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(edgeScroll)];
        [_edgeTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

//关闭定时器
- (void)stopEdgeTimer {
    if (_edgeTimer) {
        [_edgeTimer invalidate];
        _edgeTimer = nil;
    }
}

- (void)edgeScroll {
    [self setUpScrollDirection];
    switch (_scrollDirection) {
        case CNDragCellCollectionViewScrollDirectionLeft:
            {
                //这里的动画必须设为NO
                [self setContentOffset:CGPointMake(self.contentOffset.x - 4, self.contentOffset.y) animated:NO];
                _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x - 4, _tempMoveCell.center.y);
                _lastPoint.x -= 4;
            }
            break;
        case CNDragCellCollectionViewScrollDirectionRight:
            {
                [self setContentOffset:CGPointMake(self.contentOffset.x + 4, self.contentOffset.y) animated:NO];
                _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x + 4, _tempMoveCell.center.y);
                _lastPoint.x += 4;
            }
            break;
        case CNDragCellCollectionViewScrollDirectionUp:
            {
                [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y - 4) animated:NO];
                _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x, _tempMoveCell.center.y - 4);
                _lastPoint.y -= 4;
            }
            break;
        case CNDragCellCollectionViewScrollDirectionDown:
            {
                [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y + 4) animated:NO];
                _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x, _tempMoveCell.center.y + 4);
                _lastPoint.y += 4;
            }
            break;
        default:
            break;
    }
}

//设置滚动方向
- (void)setUpScrollDirection {
    _scrollDirection = CNDragCellCollectionViewScrollDirectionNone;
    if (self.bounds.size.height + self.contentOffset.y - _tempMoveCell.center.y < _tempMoveCell.bounds.size.height / 2 && self.bounds.size.height + self.contentOffset.y < self.contentSize.height) {
        _scrollDirection = CNDragCellCollectionViewScrollDirectionDown;
    }
    if (_tempMoveCell.center.y - self.contentOffset.y < _tempMoveCell.bounds.size.height / 2 && self.contentOffset.y > 0) {
        _scrollDirection = CNDragCellCollectionViewScrollDirectionUp;
    }
    if (self.bounds.size.width + self.contentOffset.x - _tempMoveCell.center.x < _tempMoveCell.bounds.size.width / 2 && self.bounds.size.width + self.contentOffset.x < self.contentSize.width) {
        _scrollDirection = CNDragCellCollectionViewScrollDirectionRight;
    }
    
    if (_tempMoveCell.center.x - self.contentOffset.x < _tempMoveCell.bounds.size.width / 2 && self.contentOffset.x > 0) {
        _scrollDirection = CNDragCellCollectionViewScrollDirectionLeft;
    }
}

- (void)shakeAllCells {
    if (!_shakeWhenMoving) {
        //没有开启抖动只需要遍历设置个cell的hidden属性
        NSArray *cells = [self visibleCells];
        for (UICollectionViewCell *cell in cells) {
            //顺便设置各个cell的hidden属性，由于有cell被hidden，其hidden状态可能被重用到其他cell上,不能直接利用_originalIndexPath相等判断，这很坑
            BOOL hidden = _sourceCellIndexPath && [self indexPathForCell:cell].item == _sourceCellIndexPath.item && [self indexPathForCell:cell].section == _sourceCellIndexPath.section;
            cell.hidden = hidden;
        }
        return;
    }
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.values = @[@(angelToRandian(-_shakeLevel)),@(angelToRandian(_shakeLevel)),@(angelToRandian(-_shakeLevel))];
    animation.repeatCount = MAXFLOAT;
    animation.duration = 0.2;
    NSArray *cells = [self visibleCells];
    for (UICollectionViewCell *cell in cells) {
        if ([self indexPathIsExcluded:[self indexPathForCell:cell]]) {
            continue;
        }
        /**如果加了shake动画就不用再加了*/
        if (![cell.layer animationForKey:@"shake"]) {
            [cell.layer addAnimation:animation forKey:@"shake"];
        }
        //顺便设置各个cell的hidden属性，由于有cell被hidden，其hidden状态可能被冲用到其他cell上
        BOOL hidden = _sourceCellIndexPath && [self indexPathForCell:cell].item == _sourceCellIndexPath.item && [self indexPathForCell:cell].section == _sourceCellIndexPath.section;
        cell.hidden = hidden;
    }
    if (![_tempMoveCell.layer animationForKey:@"shake"]) {
        [_tempMoveCell.layer addAnimation:animation forKey:@"shake"];
    }
}

- (void)stopShakeAllCells {
    if (!_shakeWhenMoving) {
        return;
    }
    NSArray *cells = [self visibleCells];
    for (UICollectionViewCell *cell in cells) {
        [cell.layer removeAllAnimations];
    }
    [_tempMoveCell.layer removeAllAnimations];
}

- (void)moveCell {
    for (UICollectionViewCell *cell in [self visibleCells]) {
        if ([self indexPathForCell:cell] == _sourceCellIndexPath || [self indexPathIsExcluded:[self indexPathForCell:cell]]) {
            continue;
        }
        //计算中心距
        CGFloat spacingX = fabs(_tempMoveCell.center.x - cell.center.x);
        CGFloat spacingY = fabs(_tempMoveCell.center.y - cell.center.y);
        if (spacingX <= _tempMoveCell.bounds.size.width / 2.0f && spacingY <= _tempMoveCell.bounds.size.height / 2.0f) {
            _moveIndexPath = [self indexPathForCell:cell];
            _sourceCell = cell;
            _sourceCellCenter = cell.center;
            //更新数据源
            [self updateDataSource];
            //移动
            //            cell.hidden = YES;
            [CATransaction begin];
            [self moveItemAtIndexPath:_sourceCellIndexPath toIndexPath:_moveIndexPath];
            [CATransaction setCompletionBlock:^{
                //do something
            }];
            [CATransaction commit];
            //通知代理
            if ([self.delegate respondsToSelector:@selector(dragCellCollectionView:moveCellFromIndexPath:toIndexPath:)]) {
                [self.delegate dragCellCollectionView:self moveCellFromIndexPath:_sourceCellIndexPath toIndexPath:_moveIndexPath];
            }
            //设置移动后的起始indexPath
            _sourceCellIndexPath = _moveIndexPath;
            break;
        }
    }
}

- (void)updateDataSource {
    NSMutableArray *temp = @[].mutableCopy;
    //获取数据源
    if ([self.dataSource respondsToSelector:@selector(dataArrayOfCollectionView:)]) {
        [temp addObjectsFromArray:[self.dataSource dataArrayOfCollectionView:self]];
    }
    //判断数据源是单个数组还是数组套数组的多section形式，YES表示数组套数组
    BOOL dataTypeCheck = ([self numberOfSections] != 1 || ([self numberOfSections] == 1 && [temp[0] isKindOfClass:[NSArray class]]));
    if (dataTypeCheck) {
        for (int i = 0; i < temp.count; i ++) {
            [temp replaceObjectAtIndex:i withObject:[temp[i] mutableCopy]];
        }
    }
    if (_moveIndexPath.section == _sourceCellIndexPath.section) {
        NSMutableArray *orignalSection = dataTypeCheck ? temp[_sourceCellIndexPath.section] : temp;
        if (_moveIndexPath.item > _sourceCellIndexPath.item) {
            for (NSUInteger i = _sourceCellIndexPath.item; i < _moveIndexPath.item ; i ++) {
                [orignalSection exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
            }
        }else {
            for (NSUInteger i = _sourceCellIndexPath.item; i > _moveIndexPath.item ; i --) {
                [orignalSection exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
            }
        }
    }else {
        NSMutableArray *orignalSection = temp[_sourceCellIndexPath.section];
        NSMutableArray *currentSection = temp[_moveIndexPath.section];
        [currentSection insertObject:orignalSection[_sourceCellIndexPath.item] atIndex:_moveIndexPath.item];
        [orignalSection removeObject:orignalSection[_sourceCellIndexPath.item]];
    }
    //将重排好的数据传递给外部
    if ([self.delegate respondsToSelector:@selector(dragCellCollectionView:newDataArrayAfterMove:)]) {
        [self.delegate dragCellCollectionView:self newDataArrayAfterMove:temp.copy];
    }
}

- (void)addContentOffsetObserver {
    if (_observing) return;
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    _observing = YES;
}

- (void)removeObserver {
    if (!_observing) return;
    [self removeObserver:self forKeyPath:@"contentOffset"];
    _observing = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (![keyPath isEqualToString:@"contentOffset"]) return;
    if (_isPanning) {
        [self shakeAllCells];
    }else if (!_isPanning){
        [self stopShakeAllCells];
    }
}

- (void)dealloc{
    [self removeObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

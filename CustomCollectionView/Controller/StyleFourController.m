//
//  StyleFourController.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/14.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "StyleFourController.h"
#import "MoveCollectionViewCell.h"
#import "SystemMovementLayout.h"

@interface StyleFourController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SystemMovementLayout *layout;
@property (nonatomic, strong) NSMutableArray *allNumbers;
@property (nonatomic, copy) NSString *number;//拷贝或剪切的数字

@end

@implementation StyleFourController

- (NSMutableArray *)allNumbers {
    if (!_allNumbers) {
        _allNumbers = [NSMutableArray array];
    }
    return _allNumbers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //这里调用的是系统提供的移动方法，iOS9以后支持
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"Move";
    for (int i=0; i<100; i++) {
        NSString *number = [NSString stringWithFormat:@"%d",i];
        [self.allNumbers addObject:number];
    }
    self.layout = [[SystemMovementLayout alloc] init];
    self.layout.columnMargin = 10;
    self.layout.rowMargin = 10;
    self.layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    self.layout.columnCount = 4;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT) collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[MoveCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self.collectionView addGestureRecognizer:longPressGesture];
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            {
                //当前按下的item的indexpath
                NSIndexPath *touchIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
                if (touchIndexPath) {
                    if (@available(iOS 9.0, *)) {
                        [self.collectionView beginInteractiveMovementForItemAtIndexPath:touchIndexPath];
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (@available(iOS 9.0, *)) {
                [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:longPress.view]];
            } else {
                // Fallback on earlier versions
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (@available(iOS 9.0, *)) {
                [self.collectionView endInteractiveMovement];
            } else {
                // Fallback on earlier versions
            }
        }
            break;
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allNumbers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MoveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = self.allNumbers[indexPath.item];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    //长按时是否显示剪切、复制、粘贴菜单
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if ([NSStringFromSelector(action) isEqualToString:@"cut:"]) {//剪切
        return YES;
    }else if ([NSStringFromSelector(action) isEqualToString:@"paste:"]){//粘贴
        return YES;
    }else if ([NSStringFromSelector(action) isEqualToString:@"copy:"]){//拷贝
        return YES;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if ([NSStringFromSelector(action) isEqualToString:@"cut:"]) {
        NSArray* itemPaths = @[indexPath];
        self.number = self.allNumbers[indexPath.item];
        [self.allNumbers removeObjectAtIndex:indexPath.item];
        [self.collectionView deleteItemsAtIndexPaths:itemPaths];
    }else if ([NSStringFromSelector(action) isEqualToString:@"paste:"]){
        NSArray* itemPaths = @[indexPath];
        if (self.number.length) {
            [self.allNumbers insertObject:self.number atIndex:indexPath.item];
            [self.collectionView insertItemsAtIndexPaths:itemPaths];
        }
    }else if ([NSStringFromSelector(action) isEqualToString:@"copy:"]){
        self.number = self.allNumbers[indexPath.item];
    }
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0) {
    if (sourceIndexPath.item != destinationIndexPath.item) {
        NSString *number = self.allNumbers[sourceIndexPath.item];
        [self.allNumbers removeObjectAtIndex:sourceIndexPath.item];
        [self.allNumbers insertObject:number atIndex:destinationIndexPath.item];
    }
}

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
//    cell.contentView.alpha = 0;
//    cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1, 1), 0);
//    [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:0 animations:^{
//        /**
//         分步动画   第一个参数是该动画开始的百分比时间  第二个参数是该动画持续的百分比时间
//         */
//        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.8 animations:^{
//            cell.contentView.alpha = 0.5;
//            cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1.2, 1.2), 0);
//        }];
//        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
//            cell.contentView.alpha = 1;
//            cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1, 1), 0);
//        }];
//    } completion:^(BOOL finished) {
//
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

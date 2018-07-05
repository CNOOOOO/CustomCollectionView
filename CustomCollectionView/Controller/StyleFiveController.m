//
//  StyleFiveController.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/19.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "StyleFiveController.h"
#import "CNDragCellCollectionView.h"
#import "MoveCollectionViewCell.h"

@interface StyleFiveController ()<CNDragCellCollectionViewDelegate, CNDragCellCollectionViewDataSource>

@property (nonatomic, strong) CNDragCellCollectionView *collectionView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation StyleFiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"Custom Move";
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 30 - 20) / 3, (SCREEN_WIDTH - 30 - 20) / 3);
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    self.collectionView = [[CNDragCellCollectionView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[MoveCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MoveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = self.data[indexPath.item];
    return cell;
}

- (NSArray *)data {
    if (!_data) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i<30; i++) {
            NSString *string = [NSString stringWithFormat:@"%d",i];
            [array addObject:string];
        }
        _data = [array copy];
    }
    return _data;
}

- (NSArray *)dataArrayOfCollectionView:(CNDragCellCollectionView *)collectionView {
    return self.data;
}

- (void)dragCellCollectionView:(CNDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray {
    _data = newDataArray;
}

- (NSArray<NSIndexPath *> *)excludeIndexPathsWhenMoveDragCellCollectionView:(CNDragCellCollectionView *)collectionView {
    //每个section的最后一个cell都不能交换
    NSMutableArray * excluedeIndexPaths = [NSMutableArray array];
    [self.data enumerateObjectsUsingBlock:^(NSArray*  _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        [excluedeIndexPaths addObject:[NSIndexPath indexPathForItem:self.data.count - 1 inSection:0]];
    }];
    return excluedeIndexPaths.copy;
}

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

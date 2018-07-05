//
//  StyleEightController.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/27.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "StyleEightController.h"
#import "FoldCell.h"
#import "FoldLayout.h"

@interface StyleEightController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation StyleEightController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Inspirations" ofType:@"plist"];
        NSArray *tmpArray = [NSArray arrayWithContentsOfFile:path];
        [tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            FoldModel *model = [FoldModel initWithDictionary:dict];
            [_dataArray addObject:model];
        }];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pattern"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"Style eight";
    FoldLayout *layout = [[FoldLayout alloc] init];
    layout.standardHeight = 100.0;
    layout.purposeHeight = 280.0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[FoldCell class] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FoldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    FoldModel *model = self.dataArray[indexPath.item];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FoldLayout *layout = (FoldLayout *)self.collectionView.collectionViewLayout;
    CGFloat offSet = layout.dragOffset *indexPath.item;
    if (self.collectionView.contentOffset.y != offSet) {
        [self.collectionView setContentOffset:CGPointMake(0, offSet) animated:YES];
    }
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

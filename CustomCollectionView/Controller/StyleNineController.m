//
//  StyleNineController.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/29.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "StyleNineController.h"
#import "DecliningCell.h"
#import "DecliningLayout.h"

@interface StyleNineController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DecliningLayout *layout;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation StyleNineController

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
    self.navigationItem.title = @"Style nine";
    
    self.layout = [[DecliningLayout alloc] init];
    self.layout.itemSize = CGSizeMake(SCREEN_WIDTH, 110);
    self.layout.minimumLineSpacing = 10;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT) collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[DecliningCell class] forCellWithReuseIdentifier:@"item"];
    //旋转后可视item的宽（斜边长度）
    CGFloat newWidth = SCREEN_WIDTH / cosf(15 * M_PI / 180.0);
    self.collectionView.contentInset = UIEdgeInsetsMake(sqrtf((newWidth / 2.0) * (newWidth / 2.0) + 55 * 55) * sinf((15 + atanf(55 / (newWidth / 2.0))) * M_PI / 180.0), 0, sqrtf((newWidth / 2.0) * (newWidth / 2.0) + 55 * 55) * sinf((15 + atanf(55 / (newWidth / 2.0))) * M_PI / 180.0), 0);
    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DecliningCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    FoldModel *model = self.dataArray[indexPath.item];
    cell.model = model;
    [cell resetImageViewCenterYWithCollectionViewBounds:collectionView.bounds];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSArray *visibleCells = [self.collectionView visibleCells];
    [visibleCells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DecliningCell *cell = obj;
        [cell resetImageViewCenterYWithCollectionViewBounds:self.collectionView.bounds];
    }];
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

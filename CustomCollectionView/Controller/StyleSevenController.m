//
//  StyleSevenController.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/27.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "StyleSevenController.h"
#import "ShopCollectionViewCell.h"
#import "ItemZoomLayout.h"

@interface StyleSevenController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation StyleSevenController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"Style seven";
    ItemZoomLayout *layout = [[ItemZoomLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH - 150, (SCREEN_WIDTH - 180) * 0.6);
    layout.sectionInset = UIEdgeInsetsMake(15, (SCREEN_WIDTH / 2.0 - (SCREEN_WIDTH - 150) / 2.0) * WIDTH_SCALE, 15, (SCREEN_WIDTH / 2.0 - (SCREEN_WIDTH - 150) / 2.0) * WIDTH_SCALE);
    layout.minimumLineSpacing = 50 * WIDTH_SCALE;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, SCREEN_WIDTH, (SCREEN_WIDTH - 180) * 0.6 * 1.3 + 30) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[ShopCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    return cell;
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

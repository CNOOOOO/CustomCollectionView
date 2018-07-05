//
//  StyleOneController.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/8.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "StyleOneController.h"
#import "HiveCollectionViewCell.h"
#import "HiveLayout.h"

@interface StyleOneController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HiveLayout *layout;

@end

@implementation StyleOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Style one";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.layout = [[HiveLayout alloc] init];
    self.layout.margin = 10;
    self.layout.numberOfColumn = 5;
    self.layout.insetTop = 10;
    self.layout.insetLeft = 15;
    self.layout.insetRight = 15;
    self.layout.insetBottom = 10;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT) collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[HiveCollectionViewCell class] forCellWithReuseIdentifier:@"hiveCell"];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 90;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hiveCell" forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击item：%ld",(long)indexPath.item);
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

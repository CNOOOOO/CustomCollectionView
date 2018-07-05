//
//  StyleTwoController.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/8.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "StyleTwoController.h"
#import "PictureCollectionViewCell.h"
#import "PictureLayout.h"

@interface StyleTwoController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PictureLayout *layout;

@end

@implementation StyleTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Style two";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.layout = [[PictureLayout alloc] init];
    self.layout.internalItemSpacing = -WIDTH_SCALE * 30;
    self.layout.itemSize = CGSizeMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - NAVI_HEIGHT - 40);
    self.layout.sectionEdgeInsets = UIEdgeInsetsMake(20, 30, 20, 30);
    self.layout.scale = 0.7;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT) collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[PictureCollectionViewCell class] forCellWithReuseIdentifier:@"pictureCell"];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pictureCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"pic"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.layout scrollToCurrentItemAtIndex:indexPath.item];
    NSLog(@"点击了item：%ld",(long)indexPath.item);
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

//
//  StyleThreeController.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/8.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "StyleThreeController.h"
#import "ProductCollectionViewCell.h"
#import "WaterfallLayout.h"
#import "ShopCollectionViewCell.h"
#import "ProductCollectionReusableView.h"

@interface StyleThreeController () <UICollectionViewDelegate, UICollectionViewDataSource, WaterfallLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WaterfallLayout *layout;

@end

@implementation StyleThreeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"Style three";
    self.layout = [[WaterfallLayout alloc] init];
    self.layout.headerHeight = 40;
    self.layout.footerHeight = 20;
    self.layout.columnCount = 2;
    self.layout.columnMargin = 10;
    self.layout.rowMargin = 10;
    self.layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    self.layout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT) collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"productCell"];
    [self.collectionView registerClass:[ShopCollectionViewCell class] forCellWithReuseIdentifier:@"shopCell"];
    [self.collectionView registerClass:[ProductCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[ProductCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 40;
    }
    return 21;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productCell" forIndexPath:indexPath];
        return cell;
    }else {
        ShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shopCell" forIndexPath:indexPath];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView;
    if (kind == UICollectionElementKindSectionHeader) {
        ProductCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.titleLabel.text = @"热卖";
        }else {
            headerView.titleLabel.text = @"品牌";
        }
        reusableView = headerView;
    }else if(kind == UICollectionElementKindSectionFooter) {
        ProductCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footerView.leftLine.hidden = YES;
        footerView.rightLine.hidden = YES;
        if (indexPath.section == 0) {
            footerView.imageView.image = [UIImage imageNamed:@"footer01"];
        }else {
            footerView.imageView.image = [UIImage imageNamed:@"footer02"];
        }
        reusableView = footerView;
    }else {
        return nil;
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){SCREEN_WIDTH,44};
}

- (CGFloat)waterfallLayout:(WaterfallLayout *)layout heightForItem:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        return 150;
    }else if (indexPath.item == 2) {
        return 200;
    }else if (indexPath.item == 4) {
        return 210;
    }else if (indexPath.item == 6) {
        return 150;
    }else if (indexPath.item == 8) {
        return 170;
    }else if (indexPath.item == 10) {
        return 280;
    }else if (indexPath.item == 12) {
        return 160;
    }else if (indexPath.item == 14) {
        return 180;
    }else if (indexPath.item == 16) {
        return 220;
    }else if (indexPath.item == 18) {
        return 150;
    }else if (indexPath.item == 20) {
        return 230;
    }else if (indexPath.item == 22) {
        return 160;
    }else if (indexPath.item == 24) {
        return 190;
    }else if (indexPath.item == 26) {
        return 220;
    }else if (indexPath.item == 28) {
        return 200;
    }else if (indexPath.item == 30) {
        return 250;
    }else if (indexPath.item == 32) {
        return 150;
    }else if (indexPath.item == 34) {
        return 210;
    }else if (indexPath.item == 36) {
        return 250;
    }else if (indexPath.item == 38) {
        return 145;
    }else if (indexPath.item == 39) {
        return 145;
    }else {
        return 300;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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

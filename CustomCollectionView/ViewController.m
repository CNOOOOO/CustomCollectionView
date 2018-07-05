//
//  ViewController.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/8.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "ViewController.h"
#import "StyleOneController.h"
#import "StyleTwoController.h"
#import "StyleThreeController.h"
#import "StyleFourController.h"
#import "StyleFiveController.h"
#import "StyleSixController.h"
#import "StyleSevenController.h"
#import "StyleEightController.h"
#import "StyleNineController.h"
#import "StyleTenController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"自定义布局CollectionView";
    [self setUpTableView];
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld种方式",(long)indexPath.row+1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        StyleOneController *oneController = [[StyleOneController alloc] init];
        [self.navigationController pushViewController:oneController animated:YES];
    }else if (indexPath.row == 1) {
        StyleTwoController *twoController = [[StyleTwoController alloc] init];
        [self.navigationController pushViewController:twoController animated:YES];
    }else if (indexPath.row == 2) {
        StyleThreeController *threeController = [[StyleThreeController alloc] init];
        [self.navigationController pushViewController:threeController animated:YES];
    }else if (indexPath.row == 3) {
        StyleFourController *fourController = [[StyleFourController alloc] init];
        [self.navigationController pushViewController:fourController animated:YES];
    }else if (indexPath.row == 4) {
        StyleFiveController *fiveController = [[StyleFiveController alloc] init];
        [self.navigationController pushViewController:fiveController animated:YES];
    }else if (indexPath.row == 5) {
        StyleSixController *sixController = [[StyleSixController alloc] init];
        [self.navigationController pushViewController:sixController animated:YES];
    }else if (indexPath.row == 6) {
        StyleSevenController *sevenController = [[StyleSevenController alloc] init];
        [self.navigationController pushViewController:sevenController animated:YES];
    }else if (indexPath.row == 7) {
        StyleEightController *eightController = [[StyleEightController alloc] init];
        [self.navigationController pushViewController:eightController animated:YES];
    }else if (indexPath.row == 8) {
        StyleNineController *nineController = [[StyleNineController alloc] init];
        [self.navigationController pushViewController:nineController animated:YES];
    }else if (indexPath.row == 9) {
        StyleTenController *tenController = [[StyleTenController alloc] init];
        [self.navigationController pushViewController:tenController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

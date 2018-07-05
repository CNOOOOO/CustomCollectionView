//
//  FoldModel.m
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/28.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "FoldModel.h"

@implementation FoldModel

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    FoldModel *model = [[FoldModel alloc] init];
    model.Title = dictionary[@"Title"];
    model.Speaker = dictionary[@"Speaker"];
    model.Room = dictionary[@"Room"];
    model.Time = dictionary[@"Time"];
    model.Background = dictionary[@"Background"];
    return model;
}

@end

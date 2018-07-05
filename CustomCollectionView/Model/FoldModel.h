//
//  FoldModel.h
//  CustomCollectionView
//
//  Created by Mac1 on 2018/6/28.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoldModel : NSObject

@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *Speaker;
@property (nonatomic, copy) NSString *Room;
@property (nonatomic, copy) NSString *Time;
@property (nonatomic, copy) NSString *Background;
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

//
//  LQYSessionCellLayoutConfig.m
//  IDoTo
//
//  Created by luoyuan on 2019/1/25.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYSessionCellLayoutConfig.h"

@interface LQYSessionCellLayoutConfig ()

@property (nonatomic, strong) NSDictionary *dict;

@end

@implementation LQYSessionCellLayoutConfig

- (nullable id<LQYSessionCellLayoutProtocol>)configBy:(NSInteger)messageType {
    id<LQYSessionCellLayoutProtocol> config = _dict[@(messageType)];
    return config;
}

@end

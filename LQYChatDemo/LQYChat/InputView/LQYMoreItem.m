//
//  LQYMoreItem.m
//  IDoTo
//
//  Created by luoyuan on 2019/2/20.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYMoreItem.h"

@implementation LQYMoreItem

+ (instancetype)item:(NSString *)selector normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage title:(NSString *)title tag:(NSUInteger)tag {
    LQYMoreItem *item  = [[LQYMoreItem alloc] init];
    item.selctor        = NSSelectorFromString(selector);
    item.normalImage    = normalImage;
    item.selectedImage  = selectedImage;
    item.title          = title;
    item.tag            = tag;
    return item;
}

@end

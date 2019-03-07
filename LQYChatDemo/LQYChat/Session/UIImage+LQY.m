//
//  UIImage+LQY.m
//  LQYChatDemo
//
//  Created by luoyuan on 2019/3/7.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "UIImage+LQY.h"
#import "LQYChatConfig.h"
#import <objc/runtime.h>

@interface UIImage ()

@end

@implementation UIImage (LQY)

#define LQYImagePathFix [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LQYImage" withExtension:@"bundle"]].resourcePath stringByAppendingString:@"/LQYImage/"]

+ (nullable UIImage *)imageLQYNamed:(NSString *)name {
    NSString *path = [LQYImagePathFix stringByAppendingString:name];
    return [UIImage imageWithContentsOfFile:path];
}

@end

//
//  LQYSessionCellSetting.h
//  IDoTo
//
//  Created by luoyuan on 2019/1/25.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LQYSessionCellSetting : NSObject

/**
 *  设置消息 Contentview 内间距
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/**
 *  设置消息 Contentview 的文字颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 *  设置消息 Contentview 的文字字体
 */
@property (nonatomic, strong) UIFont *font;

/**
 *  设置消息是否显示头像
 */
@property (nonatomic, assign) BOOL showAvatar;

/**
 *  设置消息普通模式下的背景图
 */
@property (nonatomic, strong) UIImage *normalBackgroundImage;

/**
 *  设置消息按压模式下的背景图
 */
@property (nonatomic, strong) UIImage *highLightBackgroundImage;


- (instancetype)initOnRight:(BOOL)onRight;

@end

NS_ASSUME_NONNULL_END

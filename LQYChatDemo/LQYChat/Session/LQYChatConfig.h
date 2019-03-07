//
//  LQYChatConfig.h
//  IDoTo
//
//  Created by luoyuan on 2019/1/25.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LQYSessionCellSetting.h"
#import "LQYMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@class LQYSessionSettings;

@interface LQYChatConfig : NSObject

+ (instancetype)shared;

@property (nonatomic, strong) LQYSessionSettings *leftBubbleSettings;
@property (nonatomic, strong) LQYSessionSettings *rightBubbleSettings;

@property (nonatomic, strong) UIColor *sessionViewBackgroundColor; //会话背景颜色
@property (nonatomic, assign) NSTimeInterval showTimeInterval; //显示时间间隔

- (LQYSessionCellSetting *)settingForModel:(LQYMessageModel *)model;

- (CGFloat)maxNotificationTipPadding;

@end

@interface LQYSessionSettings : NSObject

/**
 *  文本类型消息设置
 */
@property (nonatomic, strong) LQYSessionCellSetting *textSetting;

/**
 *  音频类型消息设置
 */
@property (nonatomic, strong) LQYSessionCellSetting *audioSetting;

/**
 *  视频类型消息设置
 */
@property (nonatomic, strong) LQYSessionCellSetting *videoSetting;

/**
 *  文件类型消息设置
 */
@property (nonatomic, strong) LQYSessionCellSetting *fileSetting;

/**
 *  图片类型消息设置
 */
@property (nonatomic, strong) LQYSessionCellSetting *imageSetting;

/**
 *  地理位置类型消息设置
 */
@property (nonatomic, strong) LQYSessionCellSetting *locationSetting;

/**
 *  提示类型消息设置
 */
@property (nonatomic, strong) LQYSessionCellSetting *tipSetting;

/**
 *  机器人类型消息设置
 */
@property (nonatomic, strong) LQYSessionCellSetting *robotSetting;

/**
 *  无法识别类型消息设置
 */
@property (nonatomic, strong) LQYSessionCellSetting *unsupportSetting;

/**
 *  通知类型通知消息设置
 */
@property (nonatomic, strong) LQYSessionCellSetting *notificationSetting;


- (instancetype)initOnRight:(BOOL)onRight;

@end

NS_ASSUME_NONNULL_END

//
//  LQYSessionCellLayoutProtocol.h
//  IDoTo
//
//  Created by luoyuan on 2019/1/25.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#ifndef LQYSessionCellLayoutProtocol_h
#define LQYSessionCellLayoutProtocol_h

#import <UIKit/UIKit.h>

@class LQYMessageModel;

@protocol LQYSessionCellLayoutProtocol <NSObject>

@optional

/**
 * @return 返回message的内容大小
 */
- (CGSize)contentSize:(LQYMessageModel *)model cellWidth:(CGFloat)width;


/**
 *  需要构造的cellContent类名
 */
- (NSString *)cellContent:(LQYMessageModel *)model;

/**
 *  左对齐的气泡，cell气泡距离整个cell的内间距
 */
- (UIEdgeInsets)cellInsets:(LQYMessageModel *)model;

/**
 *  左对齐的气泡，cell内容距离气泡的内间距，
 */
- (UIEdgeInsets)contentViewInsets:(LQYMessageModel *)model;

/**
 *  是否显示头像
 */
- (BOOL)shouldShowAvatar:(LQYMessageModel *)model;


/**
 *  左对齐的气泡，头像控件的 origin 点
 */
- (CGPoint)avatarMargin:(LQYMessageModel *)model;

/**
 *  左对齐的气泡，头像控件的 size
 */
- (CGSize)avatarSize:(LQYMessageModel *)model;

/**
 *  是否显示姓名
 */
- (BOOL)shouldShowNickName:(LQYMessageModel *)model;

/**
 *  左对齐的气泡，昵称控件的 origin 点
 */
- (CGPoint)nickNameMargin:(LQYMessageModel *)model;


/**
 *  消息显示在左边
 */
- (BOOL)shouldShowLeft:(LQYMessageModel *)model;


/**
 *  需要添加到Cell上的自定义视图
 */
- (NSArray *)customViews:(LQYMessageModel *)model;


/**
 *  是否开启重试叹号开关
 */
- (BOOL)disableRetryButton:(LQYMessageModel *)model;

@end

#endif /* LQYSessionCellLayoutProtocol_h */

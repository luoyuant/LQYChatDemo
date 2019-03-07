//
//  LQYMessageModel.h
//  IDoTo
//
//  Created by luoyuan on 2019/1/23.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LQYMessageType) {
    LQYMessageTypeText = 0,
    LQYMessageTypeImage = 1,
    LQYMessageTypeAudio = 2,
    LQYMessageTypeTip = 3,
    LQYMessageTypeUnknow = 4,
    LQYMessageTypeNotification = 5,
};

typedef NS_ENUM(NSInteger, LQYMessageStatus) {
    LQYMessageStatusFailed = 1,
    LQYMessageStatusSending = 2,
    LQYMessageStatusSucceed = 3,
};

@interface LQYMessageModel : NSObject

@property (nonatomic, assign) LQYMessageType messageType;
@property (nonatomic, assign) uint64_t messageId;

@property (nonatomic, assign) uint32_t userId;

@property (nullable, nonatomic, copy) NSString *text;

@property (nonatomic, assign) BOOL showNickname;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) CGPoint nameMargin;

@property (nonatomic, assign) BOOL showAvatar;
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, assign) CGSize avatarSize;
@property (nonatomic, assign) CGPoint avatarMargin;

@property (nonatomic, assign) BOOL showOnLeft;

@property (nonatomic, readonly) UIEdgeInsets contentViewInsets;

@property (nonatomic, readonly) UIEdgeInsets bubbleViewInsets;

@property (nonatomic, assign) BOOL isTimestamp; //是否是 时间戳消息
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, assign) NSTimeInterval timeInterval; //时间戳

@property (nonatomic, assign) LQYMessageStatus messageStatus;

@property (nonatomic, strong, nullable) id messageObject;

@property (nonatomic, strong) NSObject *extModel;

- (nullable Class)contentViewClass;

- (CGSize)contentSize:(CGFloat)width;

/**
 * 时间戳cell高度
 */
- (CGFloat)timestampCellHieght;

@end

NS_ASSUME_NONNULL_END

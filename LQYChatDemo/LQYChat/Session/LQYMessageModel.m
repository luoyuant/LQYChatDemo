//
//  LQYMessageModel.m
//  IDoTo
//
//  Created by luoyuan on 2019/1/23.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYMessageModel.h"
#import "LQYMessageContentView.h"
#import "LQYChatConfig.h"
#import "LQYMessageTextContentView.h"
#import "LQYSessionMessageCell.h"
#import "LQYMessageNotificationContentView.h"
#import "LQYMessageImageContentView.h"

@interface LQYMessageModel ()

@property (nonatomic, strong) NSMutableDictionary *contentSizeDict;

@end

@implementation LQYMessageModel

- (nullable Class)contentViewClass {
    switch (_messageType) {
        case LQYMessageTypeText:
            return [LQYMessageTextContentView class];
            break;
        case LQYMessageTypeTip:
        case LQYMessageTypeNotification:
            return [LQYMessageNotificationContentView class];
            break;
        case LQYMessageTypeImage:
            return [LQYMessageImageContentView class];
            break;
        case LQYMessageTypeUnknow:
            return [LQYMessageTextContentView class];
            break;
        default:
            return [LQYMessageContentView class];
            break;
    }
}

- (BOOL)showAvatar {
    return (_messageType != LQYMessageTypeTip && _messageType != LQYMessageTypeNotification);
}

- (BOOL)showNickname {
    return (_messageType != LQYMessageTypeTip && _messageType != LQYMessageTypeNotification);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _contentSizeDict = [NSMutableDictionary dictionary];
        _showNickname = true;
        _showAvatar = true;
    }
    return self;
}

- (UIEdgeInsets)contentViewInsets {
    return [[LQYChatConfig shared] settingForModel:self].contentInsets;
}

- (UIEdgeInsets)bubbleViewInsets {
    if (self.messageType == LQYMessageTypeNotification || self.messageType == LQYMessageTypeTip) {
        return UIEdgeInsetsZero;
    }
    CGFloat cellTopToBubbleTop           = 3;
    CGFloat otherNickNameHeight          = 20;
    CGFloat otherBubbleOriginX           = self.showAvatar ? 55 : 0;
    CGFloat cellBubbleButtomToCellButtom = 13;
    if (self.showNickname) {
        return UIEdgeInsetsMake(cellTopToBubbleTop + otherNickNameHeight ,otherBubbleOriginX,cellBubbleButtomToCellButtom, 0);
    } else {
        return UIEdgeInsetsMake(cellTopToBubbleTop + 7, otherBubbleOriginX, cellBubbleButtomToCellButtom, 0);
    }
}

- (CGSize)contentSize:(CGFloat)width {
    CGSize size = [self.contentSizeDict[@(width)] CGSizeValue];
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        [self updateLayoutConfig];
        Class clazz = [self contentViewClass];
        size = [clazz contentSizeForCellWidth:width model:self];
        [self.contentSizeDict setObject:[NSValue valueWithCGSize:size] forKey:@(width)];
    }
    return size;
}

- (void)updateLayoutConfig {
    _avatarMargin = CGPointMake(8.f, 10.f);
    _nameMargin = self.showAvatar ? CGPointMake(57.f, -3.f) : CGPointMake(10.f, -3.f);
    _avatarSize = CGSizeMake(42, 42);
}


- (CGFloat)timestampCellHieght {
    return 40;
}

@end

//
//  LQYChatConfig.m
//  IDoTo
//
//  Created by luoyuan on 2019/1/25.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYChatConfig.h"

@implementation LQYChatConfig

+ (instancetype)shared {
    static LQYChatConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LQYChatConfig alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _leftBubbleSettings = [[LQYSessionSettings alloc] initOnRight:false];
        _rightBubbleSettings = [[LQYSessionSettings alloc] initOnRight:true];
        
        _sessionViewBackgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1.000];
        _showTimeInterval = 120;
    }
    return self;
}

- (LQYSessionCellSetting *)settingForModel:(LQYMessageModel *)model {
    LQYSessionSettings *setting = model.showOnLeft ? self.leftBubbleSettings : self.rightBubbleSettings;
    switch (model.messageType) {
        case LQYMessageTypeText:
            return setting.textSetting;
            break;
        case LQYMessageTypeImage:
            return setting.imageSetting;
            break;
        case LQYMessageTypeAudio:
            return setting.audioSetting;
            break;
        case LQYMessageTypeNotification:
            return setting.notificationSetting;
            break;
        case LQYMessageTypeTip:
            return setting.tipSetting;
            break;
        default:
            return setting.unsupportSetting;
            break;
    }
}

- (CGFloat)maxNotificationTipPadding {
    return 20.f;
}

@end


@interface LQYSessionSettings ()

@property (nonatomic, assign) BOOL onRight;

@end

@implementation LQYSessionSettings


- (instancetype)initOnRight:(BOOL)onRight {
    self = [super init];
    if (self) {
        _onRight = onRight;
        [self setTextDefaultSetting];
        [self setAudioDefaultSetting];
        [self setVideoDefaultSetting];
        [self setFileDefaultSetting];
        [self setImageDefaultSetting];
        [self setLocationDefaultSetting];
        [self setTipDefaultSetting];
        [self setUnsupportSetting];
    }
    return self;
}

- (void)setTextDefaultSetting {
    _textSetting = [[LQYSessionCellSetting alloc] initOnRight:_onRight];
    _textSetting.contentInsets = _onRight ? UIEdgeInsetsMake(11, 11, 9, 15) : UIEdgeInsetsMake(11, 15, 9, 9);
    _textSetting.textColor = [UIColor blackColor];
    _textSetting.font = [UIFont systemFontOfSize:14];
    _textSetting.showAvatar = true;
}

- (void)setAudioDefaultSetting {
    _audioSetting = [[LQYSessionCellSetting alloc] initOnRight:_onRight];
    _audioSetting.contentInsets = _onRight ? UIEdgeInsetsMake(8, 12, 9, 14) : UIEdgeInsetsMake(8, 13, 9, 12);
    _audioSetting.textColor = [UIColor blackColor];
    _audioSetting.font = [UIFont systemFontOfSize:14];
    _audioSetting.showAvatar = true;
}

- (void)setVideoDefaultSetting {
    _videoSetting = [[LQYSessionCellSetting alloc] initOnRight:_onRight];
    _videoSetting.contentInsets = _onRight ? UIEdgeInsetsMake(3, 3, 3, 8) : UIEdgeInsetsMake(3, 8, 3, 3);
    _videoSetting.font = [UIFont systemFontOfSize:14];
    _videoSetting.showAvatar = true;
}

- (void)setFileDefaultSetting {
    _fileSetting = [[LQYSessionCellSetting alloc] initOnRight:_onRight];
    _fileSetting.contentInsets = _onRight ? UIEdgeInsetsMake(3, 3, 3, 8) : UIEdgeInsetsMake(3, 8, 3, 3);
    _fileSetting.font = [UIFont systemFontOfSize:14];
    _fileSetting.showAvatar = true;
}

- (void)setImageDefaultSetting {
    _imageSetting = [[LQYSessionCellSetting alloc] initOnRight:_onRight];
    _imageSetting.contentInsets = _onRight ? UIEdgeInsetsMake(3, 3, 3, 8) : UIEdgeInsetsMake(3, 8, 3, 3);
    _imageSetting.showAvatar = true;
}

- (void)setLocationDefaultSetting {
    _locationSetting = [[LQYSessionCellSetting alloc] initOnRight:_onRight];
    _locationSetting.contentInsets = _onRight ? UIEdgeInsetsMake(3, 3, 3, 8) : UIEdgeInsetsMake(3, 8, 3, 3);
    _locationSetting.textColor = [UIColor whiteColor];
    _locationSetting.font = [UIFont systemFontOfSize:12];
    _locationSetting.showAvatar = true;
}

- (void)setTipDefaultSetting {
    _tipSetting = [[LQYSessionCellSetting alloc] initOnRight:_onRight];
    _tipSetting.contentInsets = UIEdgeInsetsZero;
    _tipSetting.textColor = [UIColor whiteColor];
    _tipSetting.font = [UIFont systemFontOfSize:10];
    _tipSetting.showAvatar = false;
    UIImage *backgroundImage = [[UIImage imageLQYNamed:@"icon_session_time_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 20, 8, 20) resizingMode:UIImageResizingModeStretch];
    _tipSetting.normalBackgroundImage = backgroundImage;
    _tipSetting.highLightBackgroundImage = backgroundImage;
}

- (void)setUnsupportSetting {
    _unsupportSetting = [[LQYSessionCellSetting alloc] initOnRight:_onRight];
    _unsupportSetting.contentInsets = _onRight ? UIEdgeInsetsMake(11, 11, 9, 15) : UIEdgeInsetsMake(11, 15, 9, 9);
    _unsupportSetting.textColor = [UIColor blackColor];
    _unsupportSetting.font = [UIFont systemFontOfSize:14];
    _unsupportSetting.showAvatar = true;
}

@end

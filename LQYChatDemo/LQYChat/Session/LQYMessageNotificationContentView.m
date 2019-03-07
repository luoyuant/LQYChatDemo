//
//  LQYMessageNotificationContentView.m
//  IDoTo
//
//  Created by luoyuan on 2019/2/23.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYMessageNotificationContentView.h"
#import "LQYChatConfig.h"

@implementation LQYMessageNotificationContentView

+ (instancetype)shared {
    static LQYMessageNotificationContentView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LQYMessageNotificationContentView alloc] initSessionMessageContentView];
    });
    return instance;
}

+ (CGSize)contentSizeForCellWidth:(CGFloat)width model:(LQYMessageModel *)model {
    
    CGFloat padding = [LQYChatConfig shared].maxNotificationTipPadding;
    
    [LQYMessageNotificationContentView shared].label.text = model.text;
    
    CGSize size = [[LQYMessageNotificationContentView shared].label sizeThatFits:CGSizeMake(width - 2 * padding, CGFLOAT_MAX)];
    CGFloat cellPadding = 10.f;
    return CGSizeMake(width, size.height + 2 * cellPadding);
}

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.numberOfLines = 0;
        [self addSubview:_label];
    }
    return self;
}

- (void)loadModel:(LQYMessageModel *)model {
    [super loadModel:model];
    _label.text = model.text;
    
    LQYSessionCellSetting *setting = [[LQYChatConfig shared] settingForModel:model];
    _label.textColor = setting.textColor;
    _label.font = setting.font;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = [LQYChatConfig shared].maxNotificationTipPadding;
    CGRect frame = _label.frame;
    frame.size = [_label sizeThatFits:CGSizeMake(self.frame.size.width - 2 * padding, CGFLOAT_MAX)];
    _label.frame = frame;
    
    _label.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    self.bubbleImageView.frame = CGRectInset(_label.frame, -8, -4);
    
}

@end

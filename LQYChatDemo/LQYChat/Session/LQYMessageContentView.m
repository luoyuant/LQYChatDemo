//
//  LQYMessageContentView.m
//  IDoTo
//
//  Created by luoyuan on 2019/1/28.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYMessageContentView.h"
#import "LQYChatConfig.h"

@implementation LQYMessageContentView

+ (CGSize)contentSizeForCellWidth:(CGFloat)width model:(LQYMessageModel *)model {
    return CGSizeMake(220, 110);
}

- (instancetype)initSessionMessageContentView {
    CGSize defaultBubbleSize = CGSizeMake(60, 35);
    if (self = [self initWithFrame:CGRectMake(0, 0, defaultBubbleSize.width, defaultBubbleSize.height)]) {
        
        [self addTarget:self action:@selector(onTouchDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(onTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        _bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, defaultBubbleSize.width, defaultBubbleSize.height)];
        _bubbleImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_bubbleImageView];
    }
    return self;
}

- (void)loadModel:(LQYMessageModel *)model {
    _model = model;
    _bubbleImageView.image = [[LQYChatConfig shared] settingForModel:model].normalBackgroundImage;
    _bubbleImageView.highlightedImage = [[LQYChatConfig shared] settingForModel:model].highLightBackgroundImage;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bubbleImageView.frame = self.bounds;
}

- (void)onTouchDown:(id)sender {
    
}

- (void)onTouchUpInside:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onContentViewTouchUpInside:)]) {
        [self.delegate onContentViewTouchUpInside:self.model];
    }
}

- (void)onTouchUpOutside:(id)sender {
    
}

@end

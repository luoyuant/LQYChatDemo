//
//  LQYSessionMessageCell.m
//  IDoTo
//
//  Created by luoyuan on 2019/1/23.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYSessionMessageCell.h"
#import "LQYMessageTextContentView.h"
#import "LQYChatConfig.h"

@interface LQYSessionMessageCell () 


@end

@implementation LQYSessionMessageCell

@synthesize dataModel = _dataModel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutAvatar];
    [self layoutName];
    [self layoutBubbleView];
    [self layoutRetryButton];
    [self layoutActivityIndicator];
}

- (void)layoutAvatar {
    _avatarImageView.hidden = !self.dataModel.showAvatar;
    if (self.dataModel.showAvatar) {
        CGFloat cellWidth = self.bounds.size.width;
        CGFloat w = self.dataModel.avatarSize.width;
        CGFloat h = self.dataModel.avatarSize.height;
        CGFloat x = self.dataModel.showOnLeft ? self.dataModel.avatarMargin.x : (cellWidth - self.dataModel.avatarMargin.x - w);
        _avatarImageView.frame = CGRectMake(x, self.dataModel.avatarMargin.y, w, h);
        _avatarImageView.layer.masksToBounds = true;
        _avatarImageView.layer.cornerRadius = h / 2;
    }
}

- (void)layoutName {
    if (self.dataModel.showNickname) {
        CGFloat x = self.dataModel.showOnLeft ? self.dataModel.nameMargin.x : (self.bounds.size.width - self.dataModel.avatarMargin.x - self.avatarImageView.bounds.size.width - self.dataModel.nameMargin.x);
        CGFloat y = self.dataModel.nameMargin.y;
        CGFloat w = 200;
        CGFloat h = 20;
        _nameLabel.frame = CGRectMake(x, y, w, h);
        _nameLabel.textAlignment = self.dataModel.showOnLeft ? NSTextAlignmentLeft : NSTextAlignmentRight;
    }
}

- (void)layoutBubbleView {
    CGSize size  = [self.dataModel contentSize:self.frame.size.width];
    UIEdgeInsets insets = self.dataModel.contentViewInsets;
    size.width  = size.width + insets.left + insets.right;
    size.height = size.height + insets.top + insets.bottom;
    
    UIEdgeInsets contentInsets = self.dataModel.bubbleViewInsets;
    if (!self.dataModel.showOnLeft)
    {
        CGFloat protraitRightToBubble = 5.f;
        CGFloat right = self.dataModel.showAvatar ? CGRectGetMinX(self.avatarImageView.frame)  - protraitRightToBubble : self.frame.size.width;
        contentInsets.left = right - size.width;
    }
    
    CGRect frame = _bubbleView.frame;
    frame.origin.x = contentInsets.left;
    frame.origin.y = contentInsets.top;
    frame.size = size;
    _bubbleView.frame = frame;
}

- (void)layoutActivityIndicator
{
    if (_indicatorView.isAnimating) {
        CGFloat centerX = 0;
        if (!self.dataModel.showOnLeft)
        {
            centerX = CGRectGetMinX(_bubbleView.frame) - [self retryButtonBubblePadding] - CGRectGetWidth(_indicatorView.bounds) / 2;
        }
        else
        {
            centerX = CGRectGetMaxX(_bubbleView.frame) + [self retryButtonBubblePadding] +  CGRectGetWidth(_indicatorView.bounds) / 2;
        }
        self.indicatorView.center = CGPointMake(centerX, _bubbleView.center.y);
    }
}

- (void)layoutRetryButton
{
    if (!_retryButton.isHidden) {
        CGFloat centerX = 0;
        if (self.dataModel.showOnLeft)
        {
            centerX = CGRectGetMaxX(_bubbleView.frame) + [self retryButtonBubblePadding] + CGRectGetWidth(_retryButton.bounds) / 2;
        }
        else
        {
            centerX = CGRectGetMinX(_bubbleView.frame) - [self retryButtonBubblePadding] - CGRectGetWidth(_retryButton.bounds) / 2;
        }
        
        _retryButton.center = CGPointMake(centerX, _bubbleView.center.y);
    }
}

- (CGFloat)retryButtonBubblePadding {
    BOOL isFromMe = !self.dataModel.showOnLeft;
    if (self.dataModel.messageType == LQYMessageTypeAudio) {
        return isFromMe ? 15 : 13;
    }
    return isFromMe ? 8 : 10;
}

- (void)commonInit {
    _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _retryButton.frame = CGRectMake(0, 0, 20, 20);
    [_retryButton setImage:[UIImage imageNamed:@"icon_message_cell_error"] forState:UIControlStateNormal];
    [_retryButton setImage:[UIImage imageNamed:@"icon_message_cell_error"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:_retryButton];
    [_retryButton addTarget:self action:@selector(onRetryMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _indicatorView.color = [UIColor colorWithRed:0.992 green:0.341 blue:0.196 alpha:1.000];
    [self.contentView addSubview:_indicatorView];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _avatarImageView.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    _nameLabel.opaque = true;
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.hidden = true;
    [self.contentView addSubview:_nameLabel];
    
}

- (void)refreshData:(LQYMessageModel *)data {
    _dataModel = data;
    if ([self.dataModel isKindOfClass:[LQYMessageModel class]]) {
        [self refresh];
    }
}

- (void)refresh {
    
    self.backgroundColor = [LQYChatConfig shared].sessionViewBackgroundColor;
    
    [self addBubbleViewIfNotExist];
    
    if (self.dataModel.showAvatar) {
        self.avatarImageView.image = self.dataModel.avatarImage;
    }
    
    if (self.dataModel.showNickname) {
        self.nameLabel.text = self.dataModel.name;
    }
    self.nameLabel.hidden = !self.dataModel.showNickname;
    
    [_bubbleView loadModel:self.dataModel];
    
    BOOL isActivityIndicatorHidden = self.dataModel.messageStatus != LQYMessageStatusSending;
    if (isActivityIndicatorHidden)
    {
        [_indicatorView stopAnimating];
    }
    else
    {
        [_indicatorView startAnimating];
    }
    [_indicatorView setHidden:isActivityIndicatorHidden];
    [_retryButton setHidden:self.dataModel.messageStatus != LQYMessageStatusFailed];
    //[_audioPlayedIcon setHidden:[self unreadHidden]];

    //[self refreshReadButton];
    
    [self setNeedsLayout];
    
}

- (void)addBubbleViewIfNotExist {
    if (!_bubbleView || ![_bubbleView isKindOfClass:[_dataModel contentViewClass]]) {
        if (_bubbleView) {
            [_bubbleView removeFromSuperview];
        }
        _bubbleView = [[[_dataModel contentViewClass] alloc] initSessionMessageContentView];
        
        if (!_bubbleView) {
            _bubbleView = [[LQYMessageContentView alloc] initSessionMessageContentView];
        }
        _bubbleView.delegate = self;
        [self.contentView insertSubview:_bubbleView atIndex:0];
    }
}

- (void)onRetryMessage:(id)sender {
    
}

#pragma mark - LQYMessageContentViewDelegate

- (void)onContentViewTouchUpInside:(LQYMessageModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTapContentView:)]) {
        [self.delegate onTapContentView:model];
    }
}


@end

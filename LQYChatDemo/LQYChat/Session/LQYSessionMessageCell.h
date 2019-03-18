//
//  LQYSessionMessageCell.h
//  IDoTo
//
//  Created by luoyuan on 2019/1/23.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQYMessageModel.h"
#import "LQYMessageContentView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LQYMessageCellDelegate <NSObject>

@optional

- (void)onTapAvatar:(LQYMessageModel *)model;

- (void)onTapAudio:(LQYMessageModel *)model;

- (void)onTapRetryMessage:(LQYMessageModel *)model;

- (void)onTapContentView:(LQYMessageModel *)model;

@end

@interface LQYSessionMessageCell : UITableViewCell <LQYMessageContentViewDelegate>

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) LQYMessageContentView *bubbleView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIButton *retryButton;

@property (nonatomic, strong, readonly) LQYMessageModel *dataModel;

@property (nonatomic, weak) id<LQYMessageCellDelegate> delegate;

- (void)refreshData:(LQYMessageModel *)data;

@end

NS_ASSUME_NONNULL_END

//
//  LQYMessageContentView.h
//  IDoTo
//
//  Created by luoyuan on 2019/1/28.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQYMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LQYMessageContentViewDelegate <NSObject>

@optional

- (void)onContentViewTouchUpInside:(LQYMessageModel *)model;

@end

@interface LQYMessageContentView : UIControl

@property (nonatomic, strong) UIImageView * bubbleImageView;

@property (nonatomic, strong, readonly) LQYMessageModel *model;

@property (nonatomic, weak) id<LQYMessageContentViewDelegate> delegate;

+ (CGSize)contentSizeForCellWidth:(CGFloat)width model:(LQYMessageModel *)model;

- (instancetype)initSessionMessageContentView;

- (void)loadModel:(LQYMessageModel *)model;

/**
 *  手指从contentView内部抬起
 */
- (void)onTouchUpInside:(id)sender;


/**
 *  手指从contentView外部抬起
 */
- (void)onTouchUpOutside:(id)sender;

/**
 *  手指按下contentView
 */
- (void)onTouchDown:(id)sender;

@end

NS_ASSUME_NONNULL_END

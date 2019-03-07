//
//  LQYSessionTimeCell.h
//  IDoTo
//
//  Created by luoyuan on 2019/2/15.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQYMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LQYSessionTimeCell : UITableViewCell

@property (strong, nonatomic) UIImageView *timeBackgroundView;

@property (strong, nonatomic) UILabel *timeLabel;

- (void)loadModel:(LQYMessageModel *)model;

@end

NS_ASSUME_NONNULL_END

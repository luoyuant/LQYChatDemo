//
//  LQYSessionViewController.h
//  IDoTo
//
//  Created by luoyuan on 2019/1/23.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQYSessionMessageCell.h"
#import "LQYMessageModel.h"
#import "LQYInputView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LQYSessionCustomStyleDelegate <NSObject>

@optional

- (nullable UITableViewCell *)LQYTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath messageModel:(LQYMessageModel *)messageModel;

- (CGFloat)LQYTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

- (UIView *)LQYTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

@end

@interface LQYSessionViewController : UIViewController <LQYMessageCellDelegate, LQYInputDelegate, LQYInputActionDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<LQYMessageModel *> *dataArr;

@property (nonatomic, strong) LQYInputView *inputView;

@property (nonatomic, weak) id<LQYSessionCustomStyleDelegate> styleDelegate;


@end

@interface UITableView (LQY)

- (void)scrollToBottom:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END

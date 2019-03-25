//
//  LQYInputView.h
//  IDoTo
//
//  Created by luoyuan on 2019/2/18.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQYInputToolBar.h"
#import "LQYMoreItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LQYInputActionDelegate <NSObject>

@optional

- (BOOL)onTapMoreItem:(LQYMoreItem *)item;

- (void)onSendText:(NSString *)text atUsers:(NSArray *)atUsers;

- (void)onTapEmoticonBtn;

- (void)onTapVoiceBtn;

- (void)onTouchVoiceBtnDown;
- (void)onTouchVoiceBtnUpOutside;
- (void)onTouchVoiceBtnDragInside;
- (void)onTouchVoiceBtnDragOutside;
- (void)onTouchVoiceBtnCancel;

- (void)onTapMoreBtn;

- (void)shouldShowAtSelectViewController;

@end

@protocol LQYInputDelegate <NSObject>

@optional

- (void)didChangeInputHeight:(CGFloat)inputHeight;

@end

@class LQYAtUserModel;

@interface LQYInputView : UIView

@property (nonatomic, assign) NSInteger maxTextLength;

@property (nonatomic, strong) LQYInputToolBar *toolBar;
@property (nonatomic, strong) UIView *moreContainer;
@property (nonatomic, strong) UIView *emoticonContainer;

@property (nonatomic, strong) NSArray<LQYMoreItem *> *moreItems;

@property (nonatomic, assign) LQYInputType inputType;

@property (nonatomic, copy) NSString *LQYAtStartString;
@property (nonatomic, copy) NSString *LQYAtEndString;
@property (nonatomic, assign) BOOL shouldCheckAt;
@property (nonatomic, strong) NSMutableArray<LQYAtUserModel *> *atArray;

- (void)reset;

- (void)refreshStatus:(LQYInputType)status;

- (void)setInputDelegate:(id<LQYInputDelegate>)delegate;

//外部设置
- (void)setInputActionDelegate:(id<LQYInputActionDelegate>)actionDelegate;

- (void)setInputTextPlaceHolder:(NSString*)placeHolder;


@end

@interface LQYAtUserModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userId;

@end

NS_ASSUME_NONNULL_END

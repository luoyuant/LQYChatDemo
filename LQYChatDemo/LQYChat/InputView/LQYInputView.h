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

@end

@protocol LQYInputDelegate <NSObject>

@optional

- (void)didChangeInputHeight:(CGFloat)inputHeight;

@end

@interface LQYInputView : UIView

@property (nonatomic, assign) NSInteger maxTextLength;

@property (nonatomic, strong) LQYInputToolBar *toolBar;
@property (nonatomic, strong) UIView *moreContainer;
@property (nonatomic, strong) UIView *emoticonContainer;

@property (nonatomic, strong) NSArray<LQYMoreItem *> *moreItems;

@property (nonatomic, assign) LQYInputType inputType;

- (void)reset;

- (void)refreshStatus:(LQYInputType)status;

- (void)setInputDelegate:(id<LQYInputDelegate>)delegate;

//外部设置
- (void)setInputActionDelegate:(id<LQYInputActionDelegate>)actionDelegate;

- (void)setInputTextPlaceHolder:(NSString*)placeHolder;


@end

NS_ASSUME_NONNULL_END

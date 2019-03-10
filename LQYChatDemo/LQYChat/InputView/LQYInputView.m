//
//  LQYInputView.m
//  IDoTo
//
//  Created by luoyuan on 2019/2/18.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYInputView.h"
#import "LQYKeyboardInfo.h"
#import "LQYInputEmoticonContainerView.h"
#import "LQYInputMoreContainerView.h"
#import <AVFoundation/AVFoundation.h>

#define LQY_EmojiCatalog @"default"

@interface LQYInputView () <LQYInputToolBarDelegate, LQYInputEmoticonDelegate>

@property (nonatomic, strong) UIView *emoticonView;
@property (nonatomic, weak) id<LQYInputDelegate> inputDelegate;
@property (nonatomic, weak) id<LQYInputActionDelegate> actionDelegate;

@property (nonatomic, assign) CGFloat keyBoardFrameTop;

@end

@implementation LQYInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)didMoveToWindow
{
    [self setup];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    //这里不做.语法 get 操作，会提前初始化组件导致卡顿
    CGFloat toolBarHeight = _toolBar.frame.size.height;
    CGFloat containerHeight = 0;
    switch (self.inputType)
    {
        case LQYInputTypeEmoticon:
            containerHeight = _emoticonContainer.frame.size.height;
            break;
        case LQYInputTypeMore:
            containerHeight = _moreContainer.frame.size.height;
            break;
        default:
        {
            UIEdgeInsets safeArea = UIEdgeInsetsZero;
            if (@available(iOS 11.0, *))
            {
                safeArea = self.superview.safeAreaInsets;
            }
            //键盘是从最底下弹起的，需要减去安全区域底部的高度
            CGFloat keyboardDelta = [LQYKeyboardInfo shared].keyboardHeight - safeArea.bottom;
            
            //如果键盘还没有安全区域高，容器的初始值为0；否则则为键盘和安全区域的高度差值，这样可以保证 toolBar 始终在键盘上面
            containerHeight = keyboardDelta > 0 ? keyboardDelta : 0;
        }
            break;
    }
    CGFloat height = toolBarHeight + containerHeight;
    CGFloat width = self.superview ? self.superview.frame.size.width : self.frame.size.width;
    return CGSizeMake(width, height);
}


- (void)setInputDelegate:(id<LQYInputDelegate>)delegate
{
    _inputDelegate = delegate;
}

- (void)setInputActionDelegate:(id<LQYInputActionDelegate>)actionDelegate {
    _actionDelegate = actionDelegate;
}

- (void)setMoreItems:(NSArray<LQYMoreItem *> *)moreItems {
    _moreItems = moreItems;
}

- (void)reset
{
    CGRect frame = self.frame;
    frame.size.width = self.superview.frame.size.width;
    self.frame = frame;
    [self refreshStatus:LQYInputTypeText];
    [self sizeToFit];
}

- (void)refreshStatus:(LQYInputType)status
{
    self.inputType = status;
    [self.toolBar update:status];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.moreContainer.hidden = status != LQYInputTypeMore;
        self.emoticonContainer.hidden = status != LQYInputTypeEmoticon;
    });
}

- (void)setup
{
    if (!_toolBar)
    {
        _toolBar = [[LQYInputToolBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
    }
    [self addSubview:_toolBar];
    //设置placeholder
    [_toolBar setPlaceHolder:@"这里输入文字"];
    
    _toolBar.delegate = self;
    [_toolBar.emoticonBtn addTarget:self action:@selector(onTouchEmoticonBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar.moreBtn addTarget:self action:@selector(onTouchMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar.voiceBtn addTarget:self action:@selector(onTouchVoiceBtn) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar.voiceBtn addTarget:self action:@selector(onTouchVoiceBtnDown) forControlEvents:UIControlEventTouchDown];
    [_toolBar.voiceBtn addTarget:self action:@selector(onTouchVoiceBtnDragInside) forControlEvents:UIControlEventTouchDragInside];
    [_toolBar.voiceBtn addTarget:self action:@selector(onTouchVoiceBtnDragOutside) forControlEvents:UIControlEventTouchDragOutside];
    [_toolBar.voiceBtn addTarget:self action:@selector(onTouchVoiceBtnUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [_toolBar.voiceBtn addTarget:self action:@selector(onTouchVoiceBtnCancel) forControlEvents:UIControlEventTouchCancel];
    
    CGRect frame = _toolBar.frame;
    frame.size = [_toolBar sizeThatFits:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)];
    _toolBar.frame = frame;
    _toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //设置最大输入字数
    NSInteger textInputLength = 1000;
    self.maxTextLength = textInputLength;
    
    [self refreshStatus:LQYInputTypeText];
    [self sizeToFit];
}

- (void)checkMoreContainer
{
    if (!_moreContainer) {
        LQYInputMoreContainerView *moreContainer = [[LQYInputMoreContainerView alloc] initWithFrame:CGRectZero];
        CGRect frame = moreContainer.frame;
        frame.size = [moreContainer sizeThatFits:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)];
        moreContainer.frame = frame;
        moreContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        moreContainer.hidden   = YES;
        [moreContainer loadItems:_moreItems];
        moreContainer.actionDelegate = self.actionDelegate;
        _moreContainer = moreContainer;
    }
    
    //可能是外部主动设置进来的，统一放在这里添加 subview
    if (!_moreContainer.superview)
    {
        [self addSubview:_moreContainer];
    }
}

- (void)setMoreContainer:(UIView *)moreContainer
{
    _moreContainer = moreContainer;
    [self sizeToFit];
}

- (void)checkEmoticonContainer
{
    if (!_emoticonContainer) {
        LQYInputEmoticonContainerView *emoticonContainer = [[LQYInputEmoticonContainerView alloc] initWithFrame:CGRectZero];
        CGRect rect = emoticonContainer.frame;
        rect.size = [emoticonContainer sizeThatFits:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)];
        emoticonContainer.frame = rect;
        emoticonContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        emoticonContainer.delegate = self;
        emoticonContainer.hidden = YES;
        [emoticonContainer loadDefaultData];
        //emoticonContainer.config = _inputConfig;
        
        _emoticonContainer = emoticonContainer;
    }
    
    //可能是外部主动设置进来的，统一放在这里添加 subview
    if (!_emoticonContainer.superview)
    {
        [self addSubview:_emoticonContainer];
    }
}

- (void)setEmoticonContainer:(UIView *)emoticonContainer
{
    _emoticonContainer = emoticonContainer;
    [self sizeToFit];
}

#pragma mark - 外部接口

- (void)setInputTextPlaceHolder:(NSString*)placeHolder
{
    [_toolBar setPlaceHolder:placeHolder];
}

#pragma mark - private methods

- (void)setFrame:(CGRect)frame
{
    CGFloat height = self.frame.size.height;
    [super setFrame:frame];
    if (frame.size.height != height)
    {
        [self callDidChangeHeight];
    }
}

- (void)callDidChangeHeight
{
    if (_inputDelegate && [_inputDelegate respondsToSelector:@selector(didChangeInputHeight:)])
    {
        if (self.inputType == LQYInputTypeMore || self.inputType == LQYInputTypeEmoticon || self.inputType == LQYInputTypeAudio)
        {
            //这个时候需要一个动画来模拟键盘
            [UIView animateWithDuration:0.25 delay:0 options:7 animations:^{
                [self.inputDelegate didChangeInputHeight:self.frame.size.height];
            } completion:nil];
        }
        else
        {
            [_inputDelegate didChangeInputHeight:self.frame.size.height];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = _moreContainer.frame;
    frame.origin.y = self.toolBar.frame.origin.y + self.toolBar.frame.size.height;
    _moreContainer.frame = frame;
    
    frame = _emoticonContainer.frame;
    frame.origin.y = self.toolBar.frame.origin.y + self.toolBar.frame.size.height;
    _emoticonContainer.frame = frame;
}


#pragma mark - button actions
- (void)onTouchVoiceBtn {
    // image change
    
    __weak typeof(self) weakSelf = self;
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf refreshStatus:LQYInputTypeAudio];
                    if (weakSelf.toolBar.showKeyboard)
                    {
                        weakSelf.toolBar.showKeyboard = NO;
                    }
                    [self sizeToFit];
                });
                if ([self.actionDelegate respondsToSelector:@selector(onTapVoiceBtn)]) {
                    [self.actionDelegate onTapVoiceBtn];
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:nil
                                                message:@"没有麦克风权限"
                                               delegate:nil
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil] show];
                });
            }
        }];
    }
    
//    if (self.inputType!= LQYInputTypeAudio) {
//
//    }
//    else
//    {
//        if ([self.toolBar.inputBarItemTypes containsObject:@(LQYInputTypeText)])
//        {
//            [self refreshStatus:LQYInputTypeText];
//            self.toolBar.showKeyboard = YES;
//        }
//    }
}


- (void)onTouchVoiceBtnDown {
    //开始
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(onTouchVoiceBtnDown)]) {
        [self.actionDelegate onTouchVoiceBtnDown];
    }
}

- (void)onTouchVoiceBtnUpOutside {
    // cancel Recording
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(onTouchVoiceBtnUpOutside)]) {
        [self.actionDelegate onTouchVoiceBtnUpOutside];
    }
}

- (void)onTouchVoiceBtnDragInside {
    // "手指上滑，取消发送"
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(onTouchVoiceBtnDragInside)]) {
        [self.actionDelegate onTouchVoiceBtnDragInside];
    }
}

- (void)onTouchVoiceBtnDragOutside {
    // "松开手指，取消发送"
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(onTouchVoiceBtnDragOutside)]) {
        [self.actionDelegate onTouchVoiceBtnDragOutside];
    }
}

- (void)onTouchVoiceBtnCancel {
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(onTouchVoiceBtnCancel)]) {
        [self.actionDelegate onTouchVoiceBtnCancel];
    }
}

- (void)onTouchEmoticonBtn:(id)sender
{
    if (self.inputType != LQYInputTypeEmoticon) {
        if ([self.actionDelegate respondsToSelector:@selector(onTapEmoticonBtn)]) {
            [self.actionDelegate onTapEmoticonBtn];
        }
        [self checkEmoticonContainer];
        [self bringSubviewToFront:self.emoticonContainer];
        [self.emoticonContainer setHidden:NO];
        [self.moreContainer setHidden:YES];
        [self refreshStatus:LQYInputTypeEmoticon];
        [self sizeToFit];
        
        
        if (self.toolBar.showKeyboard)
        {
            self.toolBar.showKeyboard = NO;
        }
    }
    else
    {
        [self refreshStatus:LQYInputTypeText];
        self.toolBar.showKeyboard = YES;
    }
}

- (void)onTouchMoreBtn:(id)sender {
    if (self.inputType != LQYInputTypeMore)
    {
        if ([self.actionDelegate respondsToSelector:@selector(onTapMoreBtn)]) {
            [self.actionDelegate onTapMoreBtn];
        }
        [self checkMoreContainer];
        [self bringSubviewToFront:self.moreContainer];
        [self.moreContainer setHidden:NO];
        [self.emoticonContainer setHidden:YES];
        [self refreshStatus:LQYInputTypeMore];
        [self sizeToFit];
        
        if (self.toolBar.showKeyboard)
        {
            self.toolBar.showKeyboard = NO;
        }
    }
    else
    {
        [self refreshStatus:LQYInputTypeText];
        self.toolBar.showKeyboard = YES;
    }
}

- (BOOL)endEditing:(BOOL)force
{
    BOOL endEditing = [super endEditing:force];
    if (!self.toolBar.showKeyboard) {
        UIViewAnimationCurve curve = UIViewAnimationCurveEaseInOut;
        void(^animations)(void) = ^{
            [self refreshStatus:LQYInputTypeText];
            [self sizeToFit];
            if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(didChangeInputHeight:)]) {
                [self.inputDelegate didChangeInputHeight:self.frame.size.height];
            }
        };
        NSTimeInterval duration = 0.25;
        [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
    }
    return endEditing;
}


#pragma mark - LQYInputToolBarDelegate

- (BOOL)textViewShouldBeginEditing
{
    [self refreshStatus:LQYInputTypeText];
    return YES;
}

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        LQYInputEmoticonContainerView *view = (LQYInputEmoticonContainerView *)self.emoticonContainer;
        [self didPressSend:view.tabView.sendButton];
        return NO;
    }
    if ([text isEqualToString:@""] && range.length == 1 )
    {
        //非选择删除
        return [self onTextDelete];
    }
//    if ([self shouldCheckAt])
//    {
//        // @ 功能
//        [self checkAt:text];
//    }
    NSString *str = [self.toolBar.contentText stringByAppendingString:text];
    if (str.length > self.maxTextLength)
    {
        return NO;
    }
    return YES;
}


- (void)textViewDidChange
{
//    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(onTextChanged:)])
//    {
//        [self.actionDelegate onTextChanged:self];
//    }
}


- (void)toolBarDidChangeHeight:(CGFloat)height
{
    [self sizeToFit];
}



#pragma mark - NIMContactSelectDelegate
//- (void)didFinishedSelect:(NSArray *)selectedContacts
//{
//    NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
//    NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
//    option.session = self.session;
//    option.forbidaAlias = YES;
//    for (NSString *uid in selectedContacts) {
//        NSString *nick = [[NIMKit sharedKit].provider infoByUser:uid option:option].showName;
//        [str appendString:nick];
//        [str appendString:NIMInputAtEndChar];
//        if (![selectedContacts.lastObject isEqualToString:uid]) {
//            [str appendString:NIMInputAtStartChar];
//        }
//        NIMInputAtItem *item = [[NIMInputAtItem alloc] init];
//        item.uid  = uid;
//        item.name = nick;
//        [self.atCache addAtItem:item];
//    }
//    [self.toolBar insertText:str];
//}

#pragma mark - InputEmoticonProtocol
- (void)selectedEmoticon:(NSString *)emoticonID catalog:(NSString*)emotCatalogID description:(NSString *)description {
    if (!emotCatalogID) { //删除键
        [self onTextDelete];
    } else {
        if ([emotCatalogID isEqualToString:LQY_EmojiCatalog]) {
            [self.toolBar insertText:description];
        } else {
            //发送贴图消息
//            if ([self.actionDelegate respondsToSelector:@selector(onSelectChartlet:catalog:)]) {
//                [self.actionDelegate onSelectChartlet:emoticonID catalog:emotCatalogID];
//            }
        }


    }
}

- (void)didPressSend:(id)sender {
    if ([self.actionDelegate respondsToSelector:@selector(onSendText:atUsers:)] && [self.toolBar.contentText length] > 0) {
        NSString *sendText = self.toolBar.contentText;
        [self.actionDelegate onSendText:sendText atUsers:@[]];
        //[self.atCache clean];
        self.toolBar.contentText = @"";
        [self.toolBar layoutIfNeeded];
    }
}



- (BOOL)onTextDelete
{
    NSRange range = [self delRangeForEmoticon];
//    if (range.length == 1)
//    {
//        //删的不是表情，可能是@
//        NIMInputAtItem *item = [self delRangeForAt];
//        if (item) {
//            range = item.range;
//        }
//    }
    if (range.length == 1) {
        //自动删除
        return YES;
    }
    [self.toolBar deleteText:range];
    return NO;
}

- (NSRange)delRangeForEmoticon
{
    NSString *text = self.toolBar.contentText;
    NSRange range = [self rangeForPrefix:@"[" suffix:@"]"];
    NSRange selectedRange = [self.toolBar selectedRange];
    if (range.length > 1)
    {
        NSString *name = [text substringWithRange:range];
        LQYInputEmoticon *icon = [[LQYInputEmoticonManager shared] emoticonByTag:name];
        range = icon? range : NSMakeRange(selectedRange.location - 1, 1);
    }
    return range;
}


//- (NIMInputAtItem *)delRangeForAt
//{
//    NSString *text = self.toolBar.contentText;
//    NSRange range = [self rangeForPrefix:NIMInputAtStartChar suffix:NIMInputAtEndChar];
//    NSRange selectedRange = [self.toolBar selectedRange];
//    NIMInputAtItem *item = nil;
//    if (range.length > 1)
//    {
//        NSString *name = [text substringWithRange:range];
//        NSString *set = [NIMInputAtStartChar stringByAppendingString:NIMInputAtEndChar];
//        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:set]];
//        item = [self.atCache item:name];
//        range = item? range : NSMakeRange(selectedRange.location - 1, 1);
//    }
//    item.range = range;
//    return item;
//}


- (NSRange)rangeForPrefix:(NSString *)prefix suffix:(NSString *)suffix
{
    NSString *text = self.toolBar.contentText;
    NSRange range = [self.toolBar selectedRange];
    NSString *selectedText = range.length ? [text substringWithRange:range] : text;
    NSInteger endLocation = range.location;
    if (endLocation <= 0)
    {
        return NSMakeRange(NSNotFound, 0);
    }
    NSInteger index = -1;
    if ([selectedText hasSuffix:suffix]) {
        //往前搜最多20个字符，一般来讲是够了...
        NSInteger p = 20;
        for (NSInteger i = endLocation; i >= endLocation - p && i-1 >= 0 ; i--)
        {
            NSRange subRange = NSMakeRange(i - 1, 1);
            NSString *subString = [text substringWithRange:subRange];
            if ([subString compare:prefix] == NSOrderedSame)
            {
                index = i - 1;
                break;
            }
        }
    }
    return index == -1 ? NSMakeRange(endLocation - 1, 1) : NSMakeRange(index, endLocation - index);
}

@end

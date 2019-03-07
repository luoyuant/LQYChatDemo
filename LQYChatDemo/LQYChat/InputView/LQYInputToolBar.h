//
//  LQYInputToolBar.h
//  IDoTo
//
//  Created by luoyuan on 2019/2/18.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LQYInputType) {
    LQYInputTypeText,
    LQYInputTypeAudio,
    LQYInputTypeEmoticon,
    LQYInputTypeMore,
};

@protocol LQYInputToolBarDelegate <NSObject>

@optional

- (BOOL)textViewShouldBeginEditing;

- (void)textViewDidEndEditing;

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText;

- (void)textViewDidChange;

- (void)toolBarWillChangeHeight:(CGFloat)height;

- (void)toolBarDidChangeHeight:(CGFloat)height;

@end

@interface LQYInputToolBar : UIView

@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *emoticonBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIImageView *inputTextBkgImage;
@property (nonatomic, strong) UIView *bottomSeparator;

@property (nonatomic, copy) NSString *contentText;
@property (nonatomic, weak) id<LQYInputToolBarDelegate> delegate;
@property (nonatomic, assign) BOOL showKeyboard;
@property (nonatomic, assign) NSArray<NSNumber *> *inputBarItemTypes;
@property (nonatomic, assign) NSInteger maxNumberOfInputLines;

- (void)update:(LQYInputType)status;

@end

@interface LQYInputToolBar (InputText)

- (NSRange)selectedRange;

- (void)setPlaceHolder:(NSString *)placeHolder;

- (void)insertText:(NSString *)text;

- (void)deleteText:(NSRange)range;

@end


NS_ASSUME_NONNULL_END

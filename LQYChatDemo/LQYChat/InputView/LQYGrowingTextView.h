//
//  LQYGrowingTextView.h
//  IDoTo
//
//  Created by luoyuan on 2019/2/18.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LQYGrowingTextView;

@protocol LQYGrowingTextViewDelegate <NSObject>

@optional

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText;

- (BOOL)shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)range;

- (BOOL)shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)range;

- (void)textViewDidBeginEditing:(LQYGrowingTextView *)growingTextView;

- (void)textViewDidChangeSelection:(LQYGrowingTextView *)growingTextView;

- (void)textViewDidEndEditing:(LQYGrowingTextView *)growingTextView;

- (BOOL)textViewShouldBeginEditing:(LQYGrowingTextView *)growingTextView;

- (BOOL)textViewShouldEndEditing:(LQYGrowingTextView *)growingTextView;

- (void)textViewDidChange:(LQYGrowingTextView *)growingTextView;

- (void)willChangeHeight:(CGFloat)height;

- (void)didChangeHeight:(CGFloat)height;

@end

@interface LQYGrowingTextView : UIScrollView

@property (nonatomic, weak) id<LQYGrowingTextViewDelegate> textViewDelegate;

@property (nonatomic, assign) NSInteger minNumberOfLines;

@property (nonatomic, assign) NSInteger maxNumberOfLines;

@property (nonatomic, strong) UIView *inputView;

@end


@interface LQYGrowingTextView (TextView)

@property (nonatomic, copy)   NSAttributedString *placeholderAttributedText;

@property (nonatomic, copy)   NSString *text;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, assign) NSRange selectedRange;

@property (nonatomic, assign) UIDataDetectorTypes dataDetectorTypes;

@property (nonatomic, assign) BOOL editable;

@property (nonatomic, assign) BOOL selectable;

@property (nonatomic, assign) BOOL allowsEditingTextAttributes;

@property (nonatomic, copy)   NSAttributedString *attributedText;

@property (nonatomic, strong) UIView *textViewInputAccessoryView;

@property (nonatomic, assign) BOOL clearsOnInsertion;

@property (nonatomic, readonly) NSTextContainer *textContainer;

@property (nonatomic, assign)   UIEdgeInsets textContainerInset;

@property (nonatomic, readonly) NSLayoutManager *layoutManger;

@property (nonatomic, readonly) NSTextStorage *textStorage;

@property (nonatomic, copy)    NSDictionary<NSString *, id> *linkTextAttributes;

@property (nonatomic, assign)  UIReturnKeyType returnKeyType;

- (void)scrollRangeToVisible:(NSRange)range;

@end

NS_ASSUME_NONNULL_END

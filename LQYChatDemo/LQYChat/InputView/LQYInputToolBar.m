//
//  LQYInputToolBar.m
//  IDoTo
//
//  Created by luoyuan on 2019/2/18.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYInputToolBar.h"
#import "LQYGrowingTextView.h"
#import "UIImage+LQY.h"

@interface LQYInputToolBar () <LQYGrowingTextViewDelegate>

@property (nonatomic, copy) NSArray<NSNumber *> *types;

@property (nonatomic, strong) LQYGrowingTextView *inputTextView;

@property (nonatomic, assign) LQYInputType inputType;

@property (nonatomic, strong) NSDictionary *dict;

@end

@implementation LQYInputToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _emoticonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emoticonBtn setImage:[UIImage imageLQYNamed:@"input_emotion"] forState:UIControlStateNormal];
        [_emoticonBtn setImage:[UIImage imageLQYNamed:@"input_emotion"] forState:UIControlStateHighlighted];
        [_emoticonBtn sizeToFit];
        
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceBtn.frame = _emoticonBtn.frame;
        _voiceBtn.backgroundColor = [UIColor colorWithRed:0.992 green:0.341 blue:0.196 alpha:1.000];
        _voiceBtn.layer.masksToBounds = true;
        _voiceBtn.layer.cornerRadius = _voiceBtn.frame.size.height / 2;
        [_voiceBtn setImage:[UIImage imageLQYNamed:@"input_voice_white"] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage imageLQYNamed:@"input_voice_white"] forState:UIControlStateHighlighted];
        //[_voiceBtn sizeToFit];
        
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageLQYNamed:@"input_more"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageLQYNamed:@"input_more"] forState:UIControlStateHighlighted];
        [_moreBtn sizeToFit];
        
        _inputTextBkgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_inputTextBkgImage setImage:[[UIImage imageLQYNamed:@"icon_input_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 80, 15, 80) resizingMode:UIImageResizingModeStretch]];
        
        _inputTextView = [[LQYGrowingTextView alloc] initWithFrame:CGRectZero];
        _inputTextView.font = [UIFont systemFontOfSize:14.0f];
        _inputTextView.maxNumberOfLines = _maxNumberOfInputLines ? : 3;
        _inputTextView.minNumberOfLines = 1;
        _inputTextView.textColor = [UIColor blackColor];
        _inputTextView.backgroundColor = [UIColor clearColor];
        CGRect rect = CGRectZero;
        rect.size = [_inputTextView intrinsicContentSize];
        _inputTextView.frame = rect;
        _inputTextView.textViewDelegate = self;
        _inputTextView.returnKeyType = UIReturnKeySend;
        
        //顶部分割线
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        separator.backgroundColor = [UIColor lightGrayColor];
        separator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:separator];
        
        //底部分割线
        _bottomSeparator = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomSeparator.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_bottomSeparator];
        
        self.types = @[
                       @(LQYInputTypeEmoticon),
                       @(LQYInputTypeText),
                       @(LQYInputTypeAudio),
                       @(LQYInputTypeMore),
                       ];
        
    }
    return self;
}

- (void)setContentText:(NSString *)contentText {
    self.inputTextView.text = contentText;
}

- (NSString *)contentText {
    return self.inputTextView.text;
}

- (void)setInputBarItemTypes:(NSArray<NSNumber *> *)inputBarItemTypes {
    self.types = inputBarItemTypes;
    [self setNeedsLayout];
}

- (NSArray<NSNumber *> *)inputBarItemTypes {
    return _types;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat viewHeight = 0.0f;
    if (self.inputType == LQYInputTypeAudio) {
        viewHeight = 54.5;
    } else {
        //算出 TextView 的宽度
        [self adjustTextViewWidth:size.width];
        // TextView 自适应高度
        [self.inputTextView layoutIfNeeded];
        viewHeight = (int)self.inputTextView.frame.size.height;
        //得到 ToolBar 自身高度
        viewHeight = viewHeight + 2 * self.spacing + 2 * self.textViewPadding;
    }
    
    return CGSizeMake(size.width,viewHeight);
}

- (void)adjustTextViewWidth:(CGFloat)width
{
    CGFloat textViewWidth = 0;
    for (NSNumber *type in self.types) {
        if (type.integerValue == LQYInputTypeText) {
            continue;
        }
        UIView *view = [self subViewForType:type.integerValue];
        textViewWidth += view.frame.size.width;
    }
    textViewWidth += (self.spacing * (self.types.count + 1));
    CGRect frame = self.inputTextView.frame;
    frame.size.width = width  - textViewWidth - 2 * self.textViewPadding;
    self.inputTextView.frame = frame;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self.types containsObject:@(LQYInputTypeText)]) {
        CGRect frame = self.inputTextBkgImage.frame;
        frame.size = CGSizeMake(self.inputTextView.frame.size.width  + 2 * self.textViewPadding, self.inputTextView.frame.size.height + 2 * self.textViewPadding);
        self.inputTextBkgImage.frame  = frame;
    }
    
    CGFloat left = 0;
    for (NSNumber *type in self.types) {
        UIView *view  = [self subViewForType:type.integerValue];
        if (!view.superview)
        {
            [self addSubview:view];
        }
        
        CGRect frame = view.frame;
        frame.origin.x = left + self.spacing;
        view.frame = frame;
        view.center = CGPointMake(view.center.x, self.frame.size.height * .5f);
        left = view.frame.origin.x + view.frame.size.width;
    }
    
    [self adjustTextAndRecordView];
    
    //底部分割线
    CGFloat sepHeight = .5f;
    CGRect frame = _bottomSeparator.frame;
    frame.size = CGSizeMake(self.frame.size.width, sepHeight);
    frame.origin.y = self.frame.size.height - sepHeight - frame.size.height;
    _bottomSeparator.frame = frame;
}


- (void)adjustTextAndRecordView
{
    if ([self.types containsObject:@(LQYInputTypeText)])
    {
        self.inputTextView.center  = self.inputTextBkgImage.center;
        
        if (!self.inputTextView.superview)
        {
            //输入框
            [self addSubview:self.inputTextView];
        }
    }
}

- (BOOL)showKeyboard
{
    return [self.inputTextView isFirstResponder];
}


- (void)setShowKeyboard:(BOOL)showKeyboard
{
    if (showKeyboard)
    {
        [self.inputTextView becomeFirstResponder];
    }
    else
    {
        [self.inputTextView resignFirstResponder];
    }
}


- (void)update:(LQYInputType)type
{
    self.inputType = type;
    [self sizeToFit];
    
    if (type == LQYInputTypeText || type == LQYInputTypeMore)
    {
        [self.inputTextView setHidden:NO];
        [self.inputTextBkgImage setHidden:NO];
    }
    else if (type == LQYInputTypeAudio)
    {
        [self.inputTextView setHidden:false];
        [self.inputTextBkgImage setHidden:false];
    }
    else
    {
        [self.inputTextView setHidden:NO];
        [self.inputTextBkgImage setHidden:NO];
    }
}

#pragma mark - NIMGrowingTextViewDelegate
- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText
{
    BOOL should = YES;
    if ([self.delegate respondsToSelector:@selector(shouldChangeTextInRange:replacementText:)]) {
        should = [self.delegate shouldChangeTextInRange:range replacementText:replacementText];
    }
    return should;
}


- (BOOL)textViewShouldBeginEditing:(LQYGrowingTextView *)growingTextView
{
    BOOL should = YES;
    if ([self.delegate respondsToSelector:@selector(textViewShouldBeginEditing)]) {
        should = [self.delegate textViewShouldBeginEditing];
    }
    return should;
}

- (void)textViewDidEndEditing:(LQYGrowingTextView *)growingTextView
{
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing)]) {
        [self.delegate textViewDidEndEditing];
    }
}


- (void)textViewDidChange:(LQYGrowingTextView *)growingTextView
{
    if ([self.delegate respondsToSelector:@selector(textViewDidChange)]) {
        [self.delegate textViewDidChange];
    }
}

- (void)willChangeHeight:(CGFloat)height
{
    CGFloat toolBarHeight = height + 2 * self.spacing;
    if ([self.delegate respondsToSelector:@selector(toolBarWillChangeHeight:)]) {
        [self.delegate toolBarWillChangeHeight:toolBarHeight];
    }
}

- (void)didChangeHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height + 2 * self.spacing + 2 * self.textViewPadding;
    self.frame = frame;
    if ([self.delegate respondsToSelector:@selector(toolBarDidChangeHeight:)]) {
        [self.delegate toolBarDidChangeHeight:self.frame.size.height];
    }
}


#pragma mark - Get
- (UIView *)subViewForType:(LQYInputType)type {
    if (!_dict) {
        _dict = @{
                  @(LQYInputTypeAudio) : self.voiceBtn,
                  @(LQYInputTypeText)  : self.inputTextBkgImage,
                  @(LQYInputTypeEmoticon) : self.emoticonBtn,
                  @(LQYInputTypeMore)     : self.moreBtn
                  };
    }
    return _dict[@(type)];
}

- (CGFloat)spacing {
    return 6.f;
}

- (CGFloat)textViewPadding
{
    return 3.f;
}

@end


@implementation LQYInputToolBar (InputText)

- (NSRange)selectedRange
{
    return self.inputTextView.selectedRange;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    self.inputTextView.placeholderAttributedText = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
}

- (void)insertText:(NSString *)text
{
    NSRange range = self.inputTextView.selectedRange;
    NSString *replaceText = [self.inputTextView.text stringByReplacingCharactersInRange:range withString:text];
    range = NSMakeRange(range.location + text.length, 0);
    self.inputTextView.text = replaceText;
    self.inputTextView.selectedRange = range;
}

- (void)deleteText:(NSRange)range
{
    NSString *text = self.contentText;
    if (range.location + range.length <= [text length]
        && range.location != NSNotFound && range.length != 0)
    {
        NSString *newText = [text stringByReplacingCharactersInRange:range withString:@""];
        NSRange newSelectRange = NSMakeRange(range.location, 0);
        [self.inputTextView setText:newText];
        self.inputTextView.selectedRange = newSelectRange;
    }
}

@end

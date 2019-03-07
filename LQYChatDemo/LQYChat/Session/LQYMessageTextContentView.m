//
//  LQYMessageTextContentView.m
//  IDoTo
//
//  Created by luoyuan on 2019/2/12.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYMessageTextContentView.h"
#import "LQYChatConfig.h"
#import "LQYInputEmoticonManager.h"
#import "LQYInputEmoticonTabView.h"

@interface LQYMessageTextContentView () <M80AttributedLabelDelegate>

@end

@implementation LQYMessageTextContentView

+ (instancetype)shared {
    static LQYMessageTextContentView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LQYMessageTextContentView alloc] initSessionMessageContentView];
    });
    return instance;
}

+ (CGSize)contentSizeForCellWidth:(CGFloat)width model:(LQYMessageModel *)model {
    CGFloat msgBubbleMaxWidth    = (width - 130);
    CGFloat bubbleLeftToContent  = 15;
    CGFloat contentRightToBubble = 0;
    CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
    [[LQYMessageTextContentView shared].textLabel setParserText:model.text];
    return [[LQYMessageTextContentView shared].textLabel sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
}

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        _textLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _textLabel.autoDetectLinks = NO;
        _textLabel.delegate = self;
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        LQYMessageModel *model = [LQYMessageModel new];
        model.messageType = LQYMessageTypeText;
        _textLabel.font = [[LQYChatConfig shared] settingForModel:model].font;
        //_textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor blackColor];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)loadModel:(LQYMessageModel *)model {
    [super loadModel:model];
    [_textLabel setParserText:self.model.text];
    
    LQYSessionCellSetting *setting = [[LQYChatConfig shared] settingForModel:model];
    _textLabel.textColor = setting.textColor;
    _textLabel.font = setting.font;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIEdgeInsets contentInsets = [[LQYChatConfig shared] settingForModel:self.model].contentInsets;
    CGFloat tableViewWidth = self.superview.frame.size.width;
    CGSize contentsize     = [self.model contentSize:tableViewWidth];
    CGRect labelFrame      = CGRectMake(contentInsets.left, contentInsets.top, contentsize.width, contentsize.height);
    self.textLabel.frame = labelFrame;
}

- (UIImage *)chatBubbleImageForState:(UIControlState)state outgoing:(BOOL)outgoing {
    return nil;
}

#pragma mark - M80AttributedLabelDelegate
- (void)m80AttributedLabel:(M80AttributedLabel *)label
             clickedOnLink:(id)linkData {
//    NIMKitEvent *event = [[NIMKitEvent alloc] init];
//    event.eventName = NIMKitEventNameTapLabelLink;
//    event.messageModel = self.model;
//    event.data = linkData;
//    [self.delegate onCatchEvent:event];
}

@end


@implementation M80AttributedLabel (EmoticonParser)

- (void)setParserText:(NSString *)text {
    [self setText:@""];
    NSArray<NIMInputTextParserModel *> *tokens = [[LQYInputEmoticonManager shared] parseText:text];
    for (NIMInputTextParserModel *token in tokens)
    {
        if (token.type == LQYInputTextParserTypeEmoticon)
        {
            LQYInputEmoticon *emoticon = [[LQYInputEmoticonManager shared] emoticonByTag:token.text];
            UIImage *image = nil; ;
            
            if (emoticon.unicode && emoticon.unicode.length > 0) {
                [self appendText:emoticon.unicode];
            } else if (emoticon.filename &&
                     emoticon.filename.length > 0 &&
                     (image = [UIImage emoticonInKit:emoticon.filename]) != nil) {
                if (image)
                {
                    [self appendImage:image
                              maxSize:CGSizeMake(18, 18)];
                }
            }else {
                [self appendText:@"[?]"];
            }
        }
        else
        {
            NSString *text = token.text;
            [self appendText:text];
        }
    }
}

@end

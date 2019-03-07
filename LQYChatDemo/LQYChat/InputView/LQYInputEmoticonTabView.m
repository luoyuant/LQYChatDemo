//
//  LQYInputEmoticonTabView.m
//  IDoTo
//
//  Created by luoyuan on 2019/2/19.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYInputEmoticonTabView.h"
#import "LQYInputEmoticonManager.h"

const NSInteger LQYInputEmoticonTabViewHeight = 35;
const NSInteger LQYInputEmoticonSendButtonWidth = 50;

const CGFloat LQYInputLineBoarder = .5f;

@interface LQYInputEmoticonTabView ()

@property (nonatomic,strong) NSMutableArray *tabs;

@property (nonatomic,strong) NSMutableArray *seps;

@end

#define sepColor [UIColor colorWithRed:0.541 green:0.557 blue:0.576 alpha:1.000]

@implementation LQYInputEmoticonTabView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, LQYInputEmoticonTabViewHeight)];
    if (self) {
        _tabs = [[NSMutableArray alloc] init];
        _seps = [[NSMutableArray alloc] init];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_sendButton setBackgroundColor:[UIColor colorWithRed:0.000 green:0.475 blue:1.000 alpha:1.000]];
        
        CGRect rect = _sendButton.frame;
        rect.size = CGSizeMake(LQYInputEmoticonSendButtonWidth, LQYInputEmoticonTabViewHeight);
        _sendButton.frame = rect;
        [self addSubview:_sendButton];
        
        self.layer.borderColor = sepColor.CGColor;
        self.layer.borderWidth = LQYInputLineBoarder;
        
    }
    return self;
}


- (void)loadCatalogs:(NSArray *)emoticonCatalogs
{
    for (UIView *subView in [_tabs arrayByAddingObjectsFromArray:_seps]) {
        [subView removeFromSuperview];
    }
    [_tabs removeAllObjects];
    [_seps removeAllObjects];
    for (LQYInputEmoticonCatalog * catelog in emoticonCatalogs) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage fetchEmoticon:catelog.icon] forState:UIControlStateNormal];
        [button setImage:[UIImage fetchEmoticon:catelog.iconPressed] forState:UIControlStateHighlighted];
        [button setImage:[UIImage fetchEmoticon:catelog.iconPressed] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(onTouchTab:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        [self addSubview:button];
        [_tabs addObject:button];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LQYInputLineBoarder, LQYInputEmoticonTabViewHeight)];
        sep.backgroundColor = sepColor;
        [_seps addObject:sep];
        [self addSubview:sep];
    }
}

- (void)onTouchTab:(id)sender {
    NSInteger index = [self.tabs indexOfObject:sender];
    [self selectTabIndex:index];
    if ([self.delegate respondsToSelector:@selector(tabView:didSelectTabIndex:)]) {
        [self.delegate tabView:self didSelectTabIndex:index];
    }
}


- (void)selectTabIndex:(NSInteger)index{
    for (NSInteger i = 0; i < self.tabs.count ; i++) {
        UIButton *btn = self.tabs[i];
        btn.selected = i == index;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat spacing = 10;
    CGFloat left    = spacing;
    for (NSInteger index = 0; index < self.tabs.count ; index++) {
        UIButton *button = self.tabs[index];
        CGRect rect = button.frame;
        rect.origin.x = left;
        button.frame = rect;
        button.center = CGPointMake(button.center.x, self.frame.size.height * .5f);
        
        UIView *sep = self.seps[index];
        CGRect frame = sep.frame;
        frame.origin.x = (int)(button.frame.origin.x + button.frame.size.width + spacing);
        sep.frame = frame;
        left = (int)(sep.frame.origin.x + sep.frame.size.width + spacing);
    }
    CGRect frame = _sendButton.frame;
    frame.origin.x = (int)self.frame.size.width - frame.size.width;
    _sendButton.frame = frame;
}


@end

@implementation UIImage(LQYInputEmoticon)

+ (UIImage *)fetchEmoticon:(NSString *)imageNameOrPath {
    UIImage *image = [UIImage emoticonInKit:imageNameOrPath];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:imageNameOrPath];
    }
    return image;
}

+ (UIImage *)emoticonInKit:(NSString *)imageName {
    NSString *name = [emoticonBundleName stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageNamed:name];
    return image;
}

@end

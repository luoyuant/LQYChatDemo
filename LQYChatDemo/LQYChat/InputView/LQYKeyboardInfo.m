//
//  LQYKeyboardInfo.m
//  IDoTo
//
//  Created by luoyuan on 2019/2/18.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYKeyboardInfo.h"

NSNotificationName const LQYKeyboardWillChangeFrameNotification = @"LQYKeyboardWillChangeFrameNotification";
NSNotificationName const LQYKeyboardWillHideNotification        = @"LQYKeyboardWillHideNotification";

@implementation LQYKeyboardInfo

@synthesize keyboardHeight = _keyboardHeight;

+ (instancetype)shared {
    static LQYKeyboardInfo *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LQYKeyboardInfo alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _isVisiable = endFrame.origin.y != [UIApplication sharedApplication].keyWindow.frame.size.height;
    _keyboardHeight = _isVisiable? endFrame.size.height: 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:LQYKeyboardWillChangeFrameNotification object:nil userInfo:notification.userInfo];
}



- (void)keyboardWillHide:(NSNotification *)notification {
    _isVisiable = NO;
    _keyboardHeight = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:LQYKeyboardWillHideNotification object:nil userInfo:notification.userInfo];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end

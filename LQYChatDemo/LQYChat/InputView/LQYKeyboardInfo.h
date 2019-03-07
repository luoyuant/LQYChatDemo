//
//  LQYKeyboardInfo.h
//  IDoTo
//
//  Created by luoyuan on 2019/2/18.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LQYKeyboardInfo : NSObject

@property (nonatomic, assign, readonly) BOOL isVisiable;

@property (nonatomic, assign, readonly) CGFloat keyboardHeight;

+ (instancetype)shared;

UIKIT_EXTERN NSNotificationName const LQYKeyboardWillChangeFrameNotification;
UIKIT_EXTERN NSNotificationName const LQYKitKeyboardWillHideNotification;

@end

NS_ASSUME_NONNULL_END

//
//  LQYInputEmoticonButton.h
//  IDoTo
//
//  Created by luoyuan on 2019/2/19.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQYInputEmoticonManager.h"

NS_ASSUME_NONNULL_BEGIN

@class LQYInputEmoticonButton;

@protocol LQYInputEmoticonButtonDelegate <NSObject>

- (void)selectedEmoticon:(LQYInputEmoticon *)emoticon catalogID:(NSString*)catalogID;

@end

@interface LQYInputEmoticonButton : UIButton

@property (nonatomic, strong) LQYInputEmoticon *emoticonData;

@property (nonatomic, copy) NSString *catalogID;

@property (nonatomic, weak) id<LQYInputEmoticonButtonDelegate> delegate;

+ (LQYInputEmoticonButton*)iconButtonWithData:(LQYInputEmoticon *)data catalogID:(NSString *)catalogID delegate:(id<LQYInputEmoticonButtonDelegate>)delegate;

- (void)onIconSelected:(id)sender;

@end

NS_ASSUME_NONNULL_END

//
//  LQYInputEmoticonTabView.h
//  IDoTo
//
//  Created by luoyuan on 2019/2/19.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LQYInputEmoticonTabView;

@protocol LQYInputEmoticonTabDelegate <NSObject>

- (void)tabView:(LQYInputEmoticonTabView *)tabView didSelectTabIndex:(NSInteger)index;

@end

@interface LQYInputEmoticonTabView : UIControl

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, weak) id<LQYInputEmoticonTabDelegate> delegate;

- (void)selectTabIndex:(NSInteger)index;

- (void)loadCatalogs:(NSArray *)emoticonCatalogs;

@end


@interface UIImage (LQYInputEmoticon)

+ (UIImage *)fetchEmoticon:(NSString *)imageNameOrPath;

+ (UIImage *)emoticonInKit:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END

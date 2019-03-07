//
//  LQYInputEmoticonContainerView.h
//  IDoTo
//
//  Created by luoyuan on 2019/2/19.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQYPageView.h"
#import "LQYInputEmoticonManager.h"
#import "LQYInputEmoticonTabView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LQYInputEmoticonDelegate <NSObject>

@optional

- (void)didPressSend:(id)sender;

- (void)selectedEmoticon:(NSString *)emoticonID catalog:(NSString *)emotCatalogID description:(NSString  *)description;

@end

@interface LQYInputEmoticonContainerView : UIView

@property (nonatomic, strong) LQYPageView *emoticonPageView;
@property (nonatomic, strong) UIPageControl  *emotPageController;
@property (nonatomic, strong) NSArray                    *totalCatalogData;
@property (nonatomic, strong) LQYInputEmoticonCatalog    *currentCatalogData;
@property (nonatomic, readonly) NSArray *allEmoticons;
@property (nonatomic, strong) LQYInputEmoticonTabView   *tabView;
@property (nonatomic, weak)   id<LQYInputEmoticonDelegate>  delegate;

- (void)loadDefaultData;

@end

NS_ASSUME_NONNULL_END

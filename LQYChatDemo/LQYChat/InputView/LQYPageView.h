//
//  LQYPageView.h
//  IDoTo
//
//  Created by luoyuan on 2019/2/19.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LQYPageView;

@protocol LQYPageViewDataSource <NSObject>

- (NSInteger)numberOfPages:(LQYPageView *)pageView;
- (UIView *)pageView:(LQYPageView *)pageView viewInPage: (NSInteger)index;

@end

@protocol LQYPageViewDelegate <NSObject>

@optional

- (void)pageViewScrollEnd: (LQYPageView *)pageView
             currentIndex: (NSInteger)index
               totolPages: (NSInteger)pages;

- (void)pageViewDidScroll: (LQYPageView *)pageView;

- (BOOL)needScrollAnimation;

@end

@interface LQYPageView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) id<LQYPageViewDataSource> dataSource;
@property (nonatomic, weak) id<LQYPageViewDelegate> pageViewDelegate;

- (void)scrollToPage:(NSInteger)pages;

- (void)reloadData;

- (UIView *)viewAtIndex:(NSInteger)index;

- (NSInteger)currentPage;


//旋转相关方法,这两个方法必须配对调用,否则会有问题
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END

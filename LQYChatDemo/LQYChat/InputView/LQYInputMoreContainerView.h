//
//  LQYInputMoreContainerView.h
//  IDoTo
//
//  Created by luoyuan on 2019/2/20.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQYInputView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LQYInputMoreContainerView : UIView

@property (nonatomic, weak) id<LQYInputActionDelegate> actionDelegate;

- (void)loadDefaultData;

@end

NS_ASSUME_NONNULL_END

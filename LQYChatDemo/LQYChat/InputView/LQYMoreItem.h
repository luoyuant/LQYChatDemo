//
//  LQYMoreItem.h
//  IDoTo
//
//  Created by luoyuan on 2019/2/20.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LQYMoreItem : NSObject

@property (nonatomic, assign) SEL selctor;
@property (nonatomic, strong, nullable) UIImage *normalImage;
@property (nonatomic, strong, nullable) UIImage *selectedImage;
@property (nonatomic, copy, nullable) NSString *title;

+ (instancetype)item:(NSString *)selector
         normalImage:(nullable UIImage  *)normalImage
       selectedImage:(nullable UIImage  *)selectedImage
               title:(nullable NSString *)title;

@end

NS_ASSUME_NONNULL_END

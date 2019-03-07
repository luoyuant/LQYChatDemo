//
//  LQYSessionCellSetting.m
//  IDoTo
//
//  Created by luoyuan on 2019/1/25.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYSessionCellSetting.h"

@implementation LQYSessionCellSetting

- (instancetype)initOnRight:(BOOL)onRight {
    self = [super init];
    if (self) {
        if (onRight) {
            UIImage *image = [UIImage imageNamed:@"azw.9"];
            UIImage *resultImage = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.width * 0.8];
            _normalBackgroundImage = resultImage;//[[UIImage imageNamed:@"azw.9"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 25, 17, 25) resizingMode:UIImageResizingModeStretch];
            _highLightBackgroundImage = resultImage;
        } else {
            UIImage *image = [UIImage imageNamed:@"azs.9"];
            UIImage *resultImage = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.width * 0.8];
            _normalBackgroundImage = resultImage;
            _highLightBackgroundImage = resultImage;
        }
    }
    return self;
}

@end

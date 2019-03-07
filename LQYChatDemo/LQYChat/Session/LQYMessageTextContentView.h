//
//  LQYMessageTextContentView.h
//  IDoTo
//
//  Created by luoyuan on 2019/2/12.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQYMessageContentView.h"
#import "M80AttributedLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LQYMessageTextContentView : LQYMessageContentView

@property (nonatomic, strong) M80AttributedLabel *textLabel;

@end

@interface M80AttributedLabel (EmoticonParser)

- (void)setParserText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END

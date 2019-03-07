//
//  LQYInputEmoticonButton.m
//  IDoTo
//
//  Created by luoyuan on 2019/2/19.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYInputEmoticonButton.h"
#import "LQYInputEmoticonTabView.h"

@implementation LQYInputEmoticonButton

+ (LQYInputEmoticonButton *)iconButtonWithData:(LQYInputEmoticon *)data catalogID:(NSString *)catalogID delegate:( id<LQYInputEmoticonButtonDelegate>)delegate{
    LQYInputEmoticonButton* icon = [[LQYInputEmoticonButton alloc] init];
    [icon addTarget:icon action:@selector(onIconSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    
    icon.emoticonData    = data;
    icon.catalogID              = catalogID;
    icon.userInteractionEnabled = YES;
    icon.exclusiveTouch         = YES;
    icon.contentMode            = UIViewContentModeScaleToFill;
    icon.delegate               = delegate;
    if(data.unicode && data.unicode.length>0) {
        [icon setTitle:data.unicode forState:UIControlStateNormal];
        [icon setTitle:data.unicode forState:UIControlStateHighlighted];
        icon.titleLabel.font = [UIFont systemFontOfSize:32];
    }else if(data.filename && data.filename.length>0){
        UIImage *image = [UIImage fetchEmoticon:data.filename];
        [icon setImage:image forState:UIControlStateNormal];
        [icon setImage:image forState:UIControlStateHighlighted];
    }
    return icon;
}



- (void)onIconSelected:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(selectedEmoticon:catalogID:)])
    {
        [self.delegate selectedEmoticon:self.emoticonData catalogID:self.catalogID];
    }
}

@end

//
//  LQYSessionTimeCell.m
//  IDoTo
//
//  Created by luoyuan on 2019/2/15.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYSessionTimeCell.h"
#import "LQYChatConfig.h"

@implementation LQYSessionTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [LQYChatConfig shared].sessionViewBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _timeBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_timeBackgroundView];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont boldSystemFontOfSize:10.f];
        _timeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_timeLabel];
        [_timeBackgroundView setImage:[[UIImage imageNamed:@"icon_session_time_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 20, 8, 20) resizingMode:UIImageResizingModeStretch]];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_timeLabel sizeToFit];
    _timeLabel.center = CGPointMake(self.center.x, 20);
    _timeBackgroundView.frame = CGRectMake(_timeLabel.frame.origin.x - 7, _timeLabel.frame.origin.y - 2, _timeLabel.frame.size.width + 14, _timeLabel.frame.size.height + 4);
}

- (void)loadModel:(LQYMessageModel *)model {
    _timeLabel.text = model.timeString;
}

@end

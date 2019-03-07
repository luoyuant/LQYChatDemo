//
//  LQYMessageImageContentView.m
//  IDoTo
//
//  Created by luoyuan on 2019/2/25.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYMessageImageContentView.h"

@implementation LQYMessageImageContentView


+ (instancetype)shared {
    static LQYMessageImageContentView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LQYMessageImageContentView alloc] initSessionMessageContentView];
    });
    return instance;
}

+ (CGSize)contentSizeForCellWidth:(CGFloat)width model:(LQYMessageModel *)model {
    
    UIImage *image;
    if ([model.messageObject isKindOfClass:[NSData class]]) {
        image = [UIImage imageWithData:model.messageObject];
    }
    
    CGSize imageSize;
    CGFloat attachmentImageMinWidth  = (width / 4.0);
    CGFloat attachmentImageMinHeight = (width / 4.0);
    CGFloat attachmemtImageMaxWidth  = (width - 184);
    CGFloat attachmentImageMaxHeight = (width - 184);
    
    if (!CGSizeEqualToSize(image.size, CGSizeZero)) {
        imageSize = image.size;
    } else {
        imageSize = CGSizeMake(100, 200);
    }
    
    CGSize contentSize = [self sizeWithImageOriginSize:imageSize
                                                      minSize:CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight)
                                                      maxSize:CGSizeMake(attachmemtImageMaxWidth, attachmentImageMaxHeight)];
    return contentSize;
    
}

+ (CGSize)sizeWithImageOriginSize:(CGSize)originSize
                              minSize:(CGSize)imageMinSize
                              maxSize:(CGSize)imageMaxSiz {
    CGSize size;
    CGFloat imageWidth = originSize.width ,imageHeight = originSize.height;
    CGFloat imageMinWidth = imageMinSize.width, imageMinHeight = imageMinSize.height;
    CGFloat imageMaxWidth = imageMaxSiz.width,  imageMaxHeight = imageMaxSiz.height;
    if (imageWidth > imageHeight) //宽图
    {
        size.height = imageMinHeight;  //高度取最小高度
        size.width = imageWidth * imageMinHeight / imageHeight;
        if (size.width > imageMaxWidth)
        {
            size.width = imageMaxWidth;
        }
    }
    else if(imageWidth < imageHeight)//高图
    {
        size.width = imageMinWidth;
        size.height = imageHeight * imageMinWidth / imageWidth;
        if (size.height > imageMaxHeight)
        {
            size.height = imageMaxHeight;
        }
    }
    else//方图
    {
        if (imageWidth > imageMaxWidth)
        {
            size.width = imageMaxWidth;
            size.height = imageMaxHeight;
        }
        else if(imageWidth > imageMinWidth)
        {
            size.width = imageWidth;
            size.height = imageHeight;
        }
        else
        {
            size.width = imageMinWidth;
            size.height = imageMinHeight;
        }
    }
    return size;
}

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = true;
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor colorWithRed:0.831 green:0.831 blue:0.831 alpha:1.000];
        //[_imageView setFullScreenEnable];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)loadModel:(LQYMessageModel *)model {
    [super loadModel:model];
    if ([model.messageObject isKindOfClass:[NSData class]]) {
        _imageView.image = [UIImage imageWithData:model.messageObject];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    UIEdgeInsets contentInsets = self.model.contentViewInsets;
//    CGFloat tableViewWidth = self.superview.frame.size.width;
//    CGSize contentSize = [self.model contentSize:tableViewWidth];
//    CGRect imageViewFrame = CGRectMake(contentInsets.left, contentInsets.top, contentSize.width, contentSize.height);
    
    self.imageView.frame  = self.bubbleImageView.bounds;
    self.imageView.layer.mask = self.bubbleImageView.layer;
    
//    CALayer *maskLayer = [CALayer layer];
//    maskLayer.cornerRadius = 13.0;
//    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
//    maskLayer.frame = self.imageView.bounds;
//    self.imageView.layer.mask = maskLayer;
}

@end

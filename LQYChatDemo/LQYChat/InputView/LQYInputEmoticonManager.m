//
//  LQYInputEmoticonManager.m
//  IDoTo
//
//  Created by luoyuan on 2019/2/19.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYInputEmoticonManager.h"

#define LQY_EmojiLeftMargin      8
#define LQY_EmojiRightMargin     8
#define LQY_EmojiTopMargin       14
#define LQY_DeleteIconWidth      43.0
#define LQY_DeleteIconHeight     43.0
#define LQY_EmojCellHeight       46.0
#define LQY_EmojImageHeight      43.0
#define LQY_EmojImageWidth       43.0
#define LQY_EmojRows             3

//贴图
#define LQY_PicCellHeight        76.0
#define LQY_PicImageHeight       70.f
#define LQY_PicImageWidth        70.f
#define LQY_PicRows              2

#define LQY_EmojiPath @"Emoji"

@interface LQYInputEmoticonManager ()

@property (nonatomic, strong) NSArray *catalogs;
@property (nonatomic, copy)   NSDictionary *bundleEmoticonInfos;

@property (nonatomic, strong) NSCache *tokens;

@end

NSString *emoticonBundleName = @"LQYEmoticon.bundle";

@implementation LQYInputEmoticonManager

+ (instancetype)shared {
    static LQYInputEmoticonManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LQYInputEmoticonManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _tokens = [[NSCache alloc] init];
        [self parsePlist];
    }
    return self;
}

- (LQYInputEmoticonCatalog *)emoticonCatalog:(NSString *)catalogID
{
    for (LQYInputEmoticonCatalog *catalog in _catalogs)
    {
        if ([catalog.catalogID isEqualToString:catalogID])
        {
            return catalog;
        }
    }
    return nil;
}


- (LQYInputEmoticon *)emoticonByTag:(NSString *)tag
{
    LQYInputEmoticon *emoticon = nil;
    if ([tag length])
    {
        for (LQYInputEmoticonCatalog *catalog in _catalogs)
        {
            emoticon = [catalog.tag2Emoticons objectForKey:tag];
            if (emoticon)
            {
                break;
            }
        }
    }
    return emoticon;
}


- (LQYInputEmoticon *)emoticonByID:(NSString *)emoticonID
{
    LQYInputEmoticon *emoticon = nil;
    if ([emoticonID length])
    {
        for (LQYInputEmoticonCatalog *catalog in _catalogs)
        {
            emoticon = [catalog.id2Emoticons objectForKey:emoticonID];
            if (emoticon)
            {
                break;
            }
        }
    }
    return emoticon;
}

- (LQYInputEmoticon *)emoticonByCatalogID:(NSString *)catalogID
                               emoticonID:(NSString *)emoticonID
{
    LQYInputEmoticon *emoticon = nil;
    if ([emoticonID length] && [catalogID length])
    {
        for (LQYInputEmoticonCatalog *catalog in _catalogs)
        {
            if ([catalog.catalogID isEqualToString:catalogID])
            {
                emoticon = [catalog.id2Emoticons objectForKey:emoticonID];
                break;
            }
        }
    }
    return emoticon;
}

- (void)parsePlist
{
    NSMutableArray *catalogs = [NSMutableArray array];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:emoticonBundleName
                                         withExtension:nil];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    
    NSString *filepath = [bundle pathForResource:@"emoji_ios" ofType:@"plist" inDirectory:LQY_EmojiPath];
    if (filepath) {
        NSArray *array = [NSArray arrayWithContentsOfFile:filepath];
        for (NSDictionary *dict in array)
        {
            NSDictionary *info = dict[@"info"];
            NSArray *emoticons = dict[@"data"];
            
            LQYInputEmoticonCatalog *catalog = [self catalogByInfo:info
                                                         emoticons:emoticons];
            [catalogs addObject:catalog];
        }
    }
    _catalogs = catalogs;
}

- (LQYInputEmoticonCatalog *)catalogByInfo:(NSDictionary *)info
                                 emoticons:(NSArray *)emoticonsArray
{
    LQYInputEmoticonCatalog *catalog = [[LQYInputEmoticonCatalog alloc] init];
    catalog.catalogID   = info[@"id"];
    catalog.title       = info[@"title"];
    NSString *iconNamePrefix = LQY_EmojiPath;
    NSString *icon      = info[@"normal"];
    catalog.icon = [iconNamePrefix stringByAppendingPathComponent:icon];
    NSString *iconPressed = info[@"pressed"];
    catalog.iconPressed = [iconNamePrefix stringByAppendingPathComponent:iconPressed];
    
    
    NSMutableDictionary *tag2Emoticons = [NSMutableDictionary dictionary];
    NSMutableDictionary *id2Emoticons = [NSMutableDictionary dictionary];
    NSMutableArray *emoticons = [NSMutableArray array];
    
    for (NSDictionary *emoticonDict in emoticonsArray) {
        LQYInputEmoticon *emoticon  = [[LQYInputEmoticon alloc] init];
        emoticon.emoticonID     = emoticonDict[@"id"];
        emoticon.tag            = emoticonDict[@"tag"];
        emoticon.unicode        = emoticonDict[@"unicode"];
        NSString *fileName      = emoticonDict[@"file"];
        NSString *imageNamePrefix = LQY_EmojiPath;
        emoticon.filename = [imageNamePrefix stringByAppendingPathComponent:fileName];
        
        if (emoticon.emoticonID) {
            [emoticons addObject:emoticon];
            id2Emoticons[emoticon.emoticonID] = emoticon;
        }
        if (emoticon.tag) {
            tag2Emoticons[emoticon.tag] = emoticon;
        }
    }
    
    catalog.emoticons       = emoticons;
    catalog.id2Emoticons    = id2Emoticons;
    catalog.tag2Emoticons   = tag2Emoticons;
    return catalog;
}

// HOT FIX for iOS 12 load bundle resource much slower than earlier versions
- (void)preloadEmoticonResource {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __block NSMutableDictionary *emoticonInfos = [NSMutableDictionary dictionary];
        for (LQYInputEmoticonCatalog *catalog in self.catalogs) {
            NSArray *emoticons = catalog.emoticons;
            for (LQYInputEmoticon *data in emoticons) {
                UIImage *image = [UIImage imageNamed:[data.filename stringByAppendingString:emoticonBundleName]];
                emoticonInfos[data.filename] = image;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bundleEmoticonInfos = emoticonInfos;
        });
    });
}

- (nullable NSArray<NIMInputTextParserModel *> *)parseText:(NSString *)text {
    NSArray *tokens = nil;
    if ([text length])
    {
        tokens = [_tokens objectForKey:text];
        if (tokens == nil)
        {
            tokens = [self parseToken:text];
            [_tokens setObject:tokens
                        forKey:text];
        }
    }
    return tokens;
}

- (nullable NSArray<NIMInputTextParserModel *> *)parseToken:(NSString *)text
{
    NSMutableArray *tokens = [NSMutableArray array];
    static NSRegularExpression *exp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        exp = [NSRegularExpression regularExpressionWithPattern:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
                                                        options:NSRegularExpressionCaseInsensitive
                                                          error:nil];
    });
    __block NSInteger index = 0;
    [exp enumerateMatchesInString:text
                          options:0
                            range:NSMakeRange(0, [text length])
                       usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                           NSString *rangeText = [text substringWithRange:result.range];
                           if ([self emoticonByTag:rangeText])
                           {
                               if (result.range.location > index)
                               {
                                   NSString *rawText = [text substringWithRange:NSMakeRange(index, result.range.location - index)];
                                   NIMInputTextParserModel *token = [[NIMInputTextParserModel alloc] init];
                                   token.type = LQYInputTextParserTypeText;
                                   token.text = rawText;
                                   [tokens addObject:token];
                               }
                               NIMInputTextParserModel *token = [[NIMInputTextParserModel alloc] init];
                               token.type = LQYInputTextParserTypeEmoticon;
                               token.text = rangeText;
                               [tokens addObject:token];
                               
                               index = result.range.location + result.range.length;
                           }
                       }];
    
    if (index < [text length])
    {
        NSString *rawText = [text substringWithRange:NSMakeRange(index, [text length] - index)];
        NIMInputTextParserModel *token = [[NIMInputTextParserModel alloc] init];
        token.type = LQYInputTextParserTypeText;
        token.text = rawText;
        [tokens addObject:token];
    }
    return tokens;
}

@end


@implementation LQYInputEmoticon



@end


@implementation LQYInputEmoticonLayout

- (instancetype)initEmojiLayout:(CGFloat)width {
    self = [super init];
    if (self) {
        _rows            = LQY_EmojRows;
        _columes         = ((width - LQY_EmojiLeftMargin - LQY_EmojiRightMargin) / LQY_EmojImageWidth);
        _itemCountInPage = _rows * _columes -1;
        _cellWidth       = (width - LQY_EmojiLeftMargin - LQY_EmojiRightMargin) / _columes;
        _cellHeight      = LQY_EmojCellHeight;
        _imageWidth      = LQY_EmojImageWidth;
        _imageHeight     = LQY_EmojImageHeight;
        _emoji           = YES;
    }
    return self;
}

- (instancetype)initCharletLayout:(CGFloat)width {
    self = [super init];
    if (self) {
        _rows            = LQY_PicRows;
        _columes         = ((width - LQY_EmojiLeftMargin - LQY_EmojiRightMargin) / LQY_PicImageWidth);
        _itemCountInPage = _rows * _columes;
        _cellWidth       = (width - LQY_EmojiLeftMargin - LQY_EmojiRightMargin) / _columes;
        _cellHeight      = LQY_PicCellHeight;
        _imageWidth      = LQY_PicImageWidth;
        _imageHeight     = LQY_PicImageHeight;
        _emoji           = NO;
    }
    return self;
}

@end


@implementation LQYInputEmoticonCatalog



@end


@implementation NIMInputTextParserModel



@end

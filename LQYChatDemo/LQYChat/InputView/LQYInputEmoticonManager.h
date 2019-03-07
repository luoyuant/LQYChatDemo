//
//  LQYInputEmoticonManager.h
//  IDoTo
//
//  Created by luoyuan on 2019/2/19.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LQYInputEmoticon, LQYInputEmoticonLayout, LQYInputEmoticonCatalog, NIMInputTextParserModel;

@interface LQYInputEmoticonManager : NSObject

+ (instancetype)shared;

- (LQYInputEmoticonCatalog *)emoticonCatalog:(NSString *)catalogID;
- (LQYInputEmoticon *)emoticonByTag:(NSString *)tag;
- (LQYInputEmoticon *)emoticonByID:(NSString *)emoticonID;
- (LQYInputEmoticon *)emoticonByCatalogID:(NSString *)catalogID
                               emoticonID:(NSString *)emoticonID;

- (void)preloadEmoticonResource;

- (nullable NSArray<NIMInputTextParserModel *> *)parseText:(NSString *)text;

UIKIT_EXTERN NSString const *emoticonBundleName;

@end

@interface LQYInputEmoticon : NSObject

@property (nonatomic, strong) NSString *emoticonID;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, copy)   NSString *unicode;

@end

@interface LQYInputEmoticonLayout : NSObject

@property (nonatomic, assign) NSInteger rows;               //行数
@property (nonatomic, assign) NSInteger columes;            //列数
@property (nonatomic, assign) NSInteger itemCountInPage;    //每页显示几项
@property (nonatomic, assign) CGFloat   cellWidth;          //单个单元格宽
@property (nonatomic, assign) CGFloat   cellHeight;         //单个单元格高
@property (nonatomic, assign) CGFloat   imageWidth;         //显示图片的宽
@property (nonatomic, assign) CGFloat   imageHeight;        //显示图片的高
@property (nonatomic, assign) BOOL      emoji;

- (instancetype)initEmojiLayout:(CGFloat)width;

- (instancetype)initCharletLayout:(CGFloat)width;

@end

@interface LQYInputEmoticonCatalog : NSObject

@property (nonatomic, strong) LQYInputEmoticonLayout *layout;
@property (nonatomic, strong) NSString        *catalogID;
@property (nonatomic, strong) NSString        *title;
@property (nonatomic, strong) NSDictionary    *id2Emoticons;
@property (nonatomic, strong) NSDictionary    *tag2Emoticons;
@property (nonatomic, strong) NSArray         *emoticons;
@property (nonatomic, strong) NSString        *icon;             //图标
@property (nonatomic, strong) NSString        *iconPressed;      //小图标按下效果
@property (nonatomic, assign) NSInteger       pagesCount;        //分页数

@end

typedef NS_ENUM(NSInteger, LQYInputTextParserType) {
    LQYInputTextParserTypeText,
    LQYInputTextParserTypeEmoticon,
};

@interface NIMInputTextParserModel : NSObject

@property (nonatomic, copy)   NSString *text;
@property (nonatomic, assign) LQYInputTextParserType type;

@end

NS_ASSUME_NONNULL_END

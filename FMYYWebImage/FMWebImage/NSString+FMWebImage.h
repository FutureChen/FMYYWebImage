//
//  NSString+FMWebImage.h
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/15.
//  Copyright © 2016年 陈炜来. All rights reserved.
//  七牛图片地址格式拼接

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, FM_QiNiu_ImageType)
{
    FM_QiNiu_None = 0,
    FM_QiNiu_JPG,
    FM_QiNiu_PNG,
    FM_QiNiu_WEBP,
    FM_QiNiu_GIF
};

static inline NSString *FM_QiNiuImageType(FM_QiNiu_ImageType type) {
    switch (type)
    {
        case FM_QiNiu_PNG:
        {
            return @"png";
        }
        case FM_QiNiu_WEBP:
        {
            return @"webp";
        }
        case FM_QiNiu_GIF:
        {
            return @"gif";
        }
        case FM_QiNiu_JPG:
        {
            return @"jpg";
        }
     
        default:
        {
            return @"";
        }
    }
}


@interface NSString (FMWebImage)


+ (NSString *)qiniuURL:(id)URL type:(FM_QiNiu_ImageType)type;

+ (NSString *)qiniuURL:(id)URL quality:(NSInteger)quality type:(FM_QiNiu_ImageType)type;

+ (NSString *)qiniuURL:(id)URL resize:(CGSize)size quality:(NSInteger)quality type:(FM_QiNiu_ImageType)type;

- (NSString *)qiniuURLType:(FM_QiNiu_ImageType)type;

- (NSString *)qiniuURQuality:(NSInteger)quality type:(FM_QiNiu_ImageType)type;

- (NSString *)qiniuURLResize:(CGSize)size quality:(NSInteger)quality type:(FM_QiNiu_ImageType)type;

@end

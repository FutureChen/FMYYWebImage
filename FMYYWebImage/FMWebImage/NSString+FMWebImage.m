//
//  NSString+FMWebImage.m
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/15.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#import "NSString+FMWebImage.h"

@implementation NSString (FMWebImage)
/**
 *  该方法用于设置后缀字符串，只会影响传参进来的后缀，对于没传参的没影响
 *
 */
+ (NSString *)qiniuURL:(id)URL resize:(CGSize)size quality:(NSInteger)quality type:(FM_QiNiu_ImageType)type
{
    NSString *urlString = nil;
    if ([URL isKindOfClass:[NSURL class]])
    {
        NSURL *url = (NSURL *) URL;
        urlString = url.absoluteString;
    }
    else if ([URL isKindOfClass:[NSString class]])
    {
        NSString *string = (NSString *) URL;
        urlString = string;
    }
    else
    {
        return nil;
    }
    if ([urlString hasSuffix:@".com/"]) {//最后是'.com/' 则说明拼接的时候没有图片的地址,只有前缀
        return  nil;
    }
    
    
    //如果毛线合格参数都没有，则返回原地址 ，用于下载原图
    if ((quality<=0||quality>=100)&&CGSizeEqualToSize(CGSizeZero, size)&&type==FM_QiNiu_None) {
        return urlString;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    //判断是否是我们自己的图片
    if ([url.host rangeOfString:@"qiniucdn.com"].location == NSNotFound )
    {
        return urlString;
    }
    
    NSMutableString *returnMe = [[NSMutableString alloc] initWithString:urlString];
    if ([url.query rangeOfString:@"imageView2"].location == NSNotFound||url.query==nil)
    {
        [returnMe appendString:@"?imageView2/2"];
    }
    if (!CGSizeEqualToSize(CGSizeZero, size))
    {
        [[self hExpression] enumerateMatchesInString:returnMe options:0 range:NSMakeRange(0, returnMe.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (result)
            {
                [returnMe replaceCharactersInRange:result.range withString:@""];
                *stop = YES;
            }
        }];
        [[self wExpression] enumerateMatchesInString:returnMe options:0 range:NSMakeRange(0, returnMe.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (result)
            {
                [returnMe replaceCharactersInRange:result.range withString:@""];
                *stop = YES;
            }
        }];
        [returnMe appendFormat:@"/h/%d/w/%d", (int) size.height, (int) size.width];
    }
    if ((quality > 0 && quality < 100))
    {
        [[self qExpression] enumerateMatchesInString:returnMe options:0 range:NSMakeRange(0, returnMe.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (result)
            {
                [returnMe replaceCharactersInRange:result.range withString:@""];
                *stop = YES;
            }
        }];
        [returnMe appendFormat:@"/q/%ld", (long) quality];
    }
    if (type != FM_QiNiu_None)
    {
        [[self formatExpression] enumerateMatchesInString:returnMe options:0 range:NSMakeRange(0, returnMe.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (result)
            {
                [returnMe replaceCharactersInRange:result.range withString:@""];
                *stop = YES;
            }
        }];
        [returnMe appendFormat:@"/format/%@", FM_QiNiuImageType(type)];
    }
    return [NSString stringWithString:returnMe];
}

+ (NSString *)qiniuURL:(id)URL type:(FM_QiNiu_ImageType)type
{
    return [self qiniuURL:URL resize:CGSizeZero quality:100 type:type];
}

+ (NSString *)qiniuURL:(id)URL quality:(NSInteger)quality type:(FM_QiNiu_ImageType)type
{
    return [self qiniuURL:URL resize:CGSizeZero quality:quality type:type];
}

- (NSString *)qiniuURLType:(FM_QiNiu_ImageType)type
{
    return [self qiniuURLResize:CGSizeZero quality:100 type:type];
}

- (NSString *)qiniuURQuality:(NSInteger)quality type:(FM_QiNiu_ImageType)type
{
    return [self qiniuURLResize:CGSizeZero quality:quality type:type];
}

- (NSString *)qiniuURLResize:(CGSize)size quality:(NSInteger)quality type:(FM_QiNiu_ImageType)type
{
    return [self.class qiniuURL:self resize:size quality:quality type:type];
}

+ (NSRegularExpression *)hExpression
{
    static NSRegularExpression *expression = nil;
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        expression = [[NSRegularExpression alloc] initWithPattern:@"/h/\\d+" options:0 error:nil];
    });

    return expression;
}

+ (NSRegularExpression *)wExpression
{
    static NSRegularExpression *expression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        expression = [[NSRegularExpression alloc] initWithPattern:@"/w/\\d+" options:0 error:nil];
    });
    return expression;
}

+ (NSRegularExpression *)formatExpression
{
    static NSRegularExpression *expression = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        expression = [[NSRegularExpression alloc] initWithPattern:@"/format/(webp|jpg|png|gif)" options:0 error:nil];
    });
    return expression;
}

+ (NSRegularExpression *)qExpression
{
    static NSRegularExpression *expression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        expression = [[NSRegularExpression alloc] initWithPattern:@"/q/\\d+" options:0 error:nil];
    });
    return expression;
}


@end

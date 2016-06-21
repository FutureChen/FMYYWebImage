//
//  UIButton+FMWebImage.h
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/15.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FMWebImage.h"
#import "NSObject+FMWebPrivate.h"
#import "UIButton+YYWebImage.h"
#import "UIView+FMWebImagePrivate.h"
/**
 *  注释查看UIImageView+FMWebImage
 */
@interface UIButton (FMTrans)
- (void)fm_setImageWithURL:(id)url forState:(UIControlState)state;
- (void)fm_setImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(NSString *)placeholder;
- (void)fm_setImageWithURL:(id)URL forState:(UIControlState)state placeholderImage:(NSString *)placeHodler failureImage:(NSString*)failureImage;
- (void)fm_setOriginalImageURL:(id)URL forState:(UIControlState)state;
- (void)fm_setOriginalImageURL:(id)URL forState:(UIControlState)state type:(FM_QiNiu_ImageType)type;
- (void)fm_setImageWithURL:(id)URL forState:(UIControlState)state resize:(CGSize)size;
- (void)fm_setImageWithURL:(id)URL forState:(UIControlState)state resize:(CGSize)size type:(FM_QiNiu_ImageType)type;

- (void)fm_setBackgroundImageWithURL:(id)url forState:(UIControlState)state;
- (void)fm_setBackgroundImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(NSString *)placeholder;
- (void)fm_setBackgroundImageWithURL:(id)URL forState:(UIControlState)state placeholderImage:(NSString *)placeHodler failureImage:(NSString*)failureImage;
- (void)fm_setOriginalBackGroundImageURL:(id)URL forState:(UIControlState)state;
- (void)fm_setOriginalBackGroundImageURL:(id)URL forState:(UIControlState)state type:(FM_QiNiu_ImageType)type;
- (void)fm_setBackgroundImageWithURL:(id)URL forState:(UIControlState)state resize:(CGSize)size;
- (void)fm_setBackgroundImageWithURL:(id)URL forState:(UIControlState)state resize:(CGSize)size type:(FM_QiNiu_ImageType)type;

/**
 *  原始方法
 *
 *  @param imageURL      图片地址
 *  @param placeholder   占位图
 *  @param failureholder 图片下载失败的时候的占位图
 *  @param quality       图片质量
 *  @param size          图片尺寸 如果传入CGZero则原始大小
 *  @param imageType     图片格式 ， webp、png
 *  @param options
 *  @param progress      进度
 *  @param transform     可以在这里对图片进行一次处理
 *  @param completion    完成的回调
 */
- (void)fm_org_setImageWithURL:(NSString *)imageURL
                      forState:(UIControlState)state
                   placeholder:(id)placeholder
                  failureImage:(id)failureholder
                       quality:(NSInteger)quality
                          size:(CGSize)size
                     imageType:(FM_QiNiu_ImageType)imageType
                       options:(YYWebImageOptions)options
                      progress:( YYWebImageProgressBlock)progress
                     transform:( YYWebImageTransformBlock)transform
                    completion:( YYWebImageCompletionBlock)completion;

- (void)fm_org_setBackGroundImageWithURL:(id)imageURL
                                forState:(UIControlState)state
                             placeholder:(id)placeholder
                            failureImage:(id)failureholder
                                 quality:(NSInteger)quality
                                    size:(CGSize)size
                               imageType:(FM_QiNiu_ImageType)imageType
                                 options:(YYWebImageOptions)options
                                progress:( YYWebImageProgressBlock)progress
                               transform:( YYWebImageTransformBlock)transform
                              completion:( YYWebImageCompletionBlock)completion;
@end

@interface UIButton (FMWebImage)


@end

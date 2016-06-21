//
//  UIImageView+FMWebImage.h
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/15.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FMWebImage.h"
#import "UIView+FMWebImagePrivate.h"
#import "UIImageView+YYWebImage.h"

/**
 *  负责请求图片url的拼接
 */
@interface UIImageView (FMTrans)
/**
 *  下载图片
 *
 *  下载失败显示系统
 *  @param URL 可以是NSString 也可以是 NSURL
 *  @param 显示静态方法中设置的默认 展位图片
 */
- (void)fm_setImageWithURL:(id)URL;

/**
 *  下载图片
 *  @param URL 可以是NSString 也可以是 NSURL
 *  @param placeHodler 占位图和失败图
 */
- (void)fm_setImageWithURL:(id)URL placeholderImage:(NSString *)placeHodler;
/**
 *  下载图片
 *  @param URL 可以是NSString 也可以是 NSURL
 *  @param placeHodler 下载图片时显示占位图
 *  @param failureImage下载失败显示失败图
 */
- (void)fm_setImageWithURL:(id)URL placeholderImage:(NSString *)placeHodler failureImage:(NSString*)failureImage;

/**
 *   @brief  下载原始图片，用在查看大图的时候，或者不需要wep格式的时候
 */
- (void)fm_setOriginalImageURL:(id)URL;

/**
 *  下载原尺寸的图，改格式
 */
- (void)fm_setOriginalImageURL:(id)URL type:(FM_QiNiu_ImageType)type;
/**
 *  强制获取某尺寸的图，不会自动根据控件获取,默认是webP的图
 *  @param URL  可以是NSString 也可以是 NSURL
 *  @param size 强制撸的size
 */
- (void)fm_setImageWithURL:(id)URL resize:(CGSize)size;
- (void)fm_setImageWithURL:(id)URL resize:(CGSize)size type:(FM_QiNiu_ImageType)type;


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
- (void)fm_org_setImageWithURL:(id )imageURL
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















@interface UIImageView (FMWebImage)


//必须在调用下载方法之前进行赋值
-(void)fm_setContentMode:(UIViewContentMode)contentMode forRequestState:(FM_WebImageState)requestState;
-(void)fm_setBackGroundColor:(UIColor *)color forRequestState:(FM_WebImageState)requestState;//设置请求状态下的背景颜色



@end

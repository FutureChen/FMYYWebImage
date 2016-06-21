//
//  YYWebImageManager+FMWebImage.m
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/15.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#import "YYWebImageManager+FMWebImage.h"
#import "FMWebImageManager.h"
#import <objc/runtime.h>
#import "NSString+FMWebImage.h"
@implementation YYWebImageManager (FMWebImage)
+ (void)load
{
    
    [super load];
    Method origMethod = class_getInstanceMethod([YYWebImageManager class],
                                                @selector(requestImageWithURL:options:progress:transform:completion:));
    Method replacingMethod = class_getInstanceMethod([YYWebImageManager class],
                                                     @selector(fm_requestImageWithURL:options:progress:transform:completion:));
    method_exchangeImplementations(origMethod, replacingMethod);
    
    
    
}
- (nullable YYWebImageOperation *)fm_requestImageWithURL:(NSURL *)url
                                              options:(YYWebImageOptions)options
                                             progress:(nullable YYWebImageProgressBlock)progress
                                            transform:(nullable YYWebImageTransformBlock)transform
                                           completion:(nullable YYWebImageCompletionBlock)completion
{
    NSURL *downLoadUrl=url;
    NSString *downLoadImageURLString=url.absoluteString;
    //    if ([downLoadImageURLString hasSuffix:@"/"]) {//最后是'/' 则说明拼接的时候没有图片的地址
    //        return  [self mm_downloadImageWithURL:nil options:options progress:progressBlock completed:completedBlock];
    //    }
    //下载图片的时候，负责录入图片质量参数
    //在蜂窝状态下会自动降质量
    if ([FMWebImageManager shareInstance].s_imageNetworkType == FMImageNetworkTypeWWAN && [FMWebImageManager shareInstance].s_qiniuQualityAutoChange) {
        BOOL hasCache = [[YYImageCache sharedCache]getImageForKey :downLoadImageURLString];
        //降质量的状态下，如果原来缓存存在图片，直接显示，不用再请求
        if (!hasCache) {//如果没有缓存，则下载模糊的图片
            downLoadImageURLString =[NSString qiniuURL:downLoadImageURLString resize:CGSizeZero quality:[FMWebImageManager shareInstance].s_qiniuImageQuality type:FM_QiNiu_None];
        }
        downLoadUrl= [NSURL URLWithString:downLoadImageURLString];
    }
    
//    NSLog(@"downLoadImageURLString %@ network:%ld autoChange:%d",downLoadImageURLString,[FMWebImageManager shareInstance].s_imageNetworkType,[FMWebImageManager shareInstance].s_qiniuQualityAutoChange);
    return  [self fm_requestImageWithURL:downLoadUrl options:options progress:progress transform:transform completion:completion];
}
@end

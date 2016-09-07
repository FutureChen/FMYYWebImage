//
//  UIButton+FMWebImage.m
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/15.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#import "UIButton+FMWebImage.h"
#import <objc/runtime.h>
#import "UITapGestureRecognizer+FMWeb.h"


@interface UIButton (FM_WebImage_Private)
@end
@implementation UIButton (FMWebImage)

#pragma mark main download method
- (void)fm_privateMainThreadBackGroundDownloadURL:(NSString*)downLoadImageURLString forState:(UIControlState)state options:(YYWebImageOptions)options progress:(nullable YYWebImageProgressBlock)progress
                                        transform:(nullable YYWebImageTransformBlock)transform
                                       completion:(nullable YYWebImageCompletionBlock)completion
{
    self.fm_downloadError = nil;
    [self setFm_imageLoadedURL:nil];
    [self yy_cancelImageRequestForState:state];
    self.fm_requestState = FM_WebImageDownloading;
    self.fm_downloadProgress = 0;
    
    YYWebImageOptions finOptions=options;
    if (finOptions==0) {
        finOptions=FMWeb_DefaultOptions;
    }
    UIImage *image= [self imageForState:state];
    
    if ([self.fm_imageLoadedURL isEqualToString:downLoadImageURLString] && image && self.fm_requestState == FM_WebImageDownloadSucceed) {
        ///url 相同并且有图片 就不去走下载图片的流程  ,同一张图，置空，重新再下，这个判断会出问题
        //        self.fm_downloadComplete(self.image);
        //        return;
    }
    ///正式开始下载
    //            [self fm_privatePrepareDownloadforState:state];
    
    FM_WEB_WEAKSELF
    [self yy_setImageWithURL:[NSURL URLWithString:downLoadImageURLString] forState:state placeholder:[self fm_getPlaceholderImage] options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (progress)
        {progress( receivedSize, expectedSize);}
        
        dispatch_async(dispatch_get_main_queue(), ^{
            FM_WEB_STRONGSELF(weakSelf)
            if (strongSelf.fm_downloadProgress < 1) {
                strongSelf.fm_downloadProgress = MAX(0, MIN(1, receivedSize / (CGFloat) expectedSize));
            }
        });
    } transform:transform completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        FM_WEB_STRONGSELF(weakSelf)
        
        strongSelf.fm_downloadError = error;
        ///加载完成后 储存downloadImageURL
        [strongSelf setFm_imageLoadedURL:downLoadImageURLString];
        if (!error && image&&stage==YYWebImageStageFinished) {
            strongSelf.fm_requestState = FM_WebImageDownloadSucceed;
        }
        else {
            NSLog(@"error = %@  url:%@  self%p", error,url ,self);
            if (stage==YYWebImageStageFinished) {//YYImage请求未完成被取消,返回error=null
                strongSelf.fm_requestState = FM_WebImageDownloadFailed;
            }
            
        }
        //        [strongSelf fm_setupTapGesture];
        if (strongSelf.fm_downloadComplete) {
            strongSelf.fm_downloadComplete(strongSelf,image);
            //            [self fm_setShowContentMode:[self fm_failureContentMode] andImage:[self fm_getFailureImage]];
            [self setImage:[self fm_getFailureImage] forState:state];
        }
        if (completion) {
            completion(image, url, from, stage, error);
        }
        
    }];
    
}
- (void)fm_privateMainThreadDownloadURL:(NSString*)downLoadImageURLString forState:(UIControlState)state options:(YYWebImageOptions)options progress:(nullable YYWebImageProgressBlock)progress
                              transform:(nullable YYWebImageTransformBlock)transform
                             completion:(nullable YYWebImageCompletionBlock)completion
{
    
    self.fm_downloadError = nil;
    [self setFm_imageLoadedURL:nil];
    [self yy_cancelImageRequestForState:state];
    self.fm_requestState = FM_WebImageDownloading;
    self.fm_downloadProgress = 0;
    YYWebImageOptions finOptions=options;
    if (finOptions==0) {
        finOptions=FMWeb_DefaultOptions;
    }
    UIImage *image= [self imageForState:state];
    if ([self.fm_imageLoadedURL isEqualToString:downLoadImageURLString] && image && self.fm_requestState == FM_WebImageDownloadSucceed) {
        ///url 相同并且有图片 就不去走下载图片的流程  ,同一张图，置空，重新再下，这个判断会出问题
        //        self.fm_downloadComplete(self.image);
        //        return;
    }
    ///正式开始下载
    //            [self fm_privatePrepareDownloadforState:state];
    
    FM_WEB_WEAKSELF
    [self yy_setBackgroundImageWithURL:[NSURL URLWithString:downLoadImageURLString] forState:state placeholder:[self fm_getPlaceholderImage] options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (progress)
        {progress( receivedSize, expectedSize);}
        
        dispatch_async(dispatch_get_main_queue(), ^{
            FM_WEB_STRONGSELF(weakSelf)
            if (strongSelf.fm_downloadProgress < 1) {
                strongSelf.fm_downloadProgress = MAX(0, MIN(1, receivedSize / (CGFloat) expectedSize));
            }
        });
    } transform:transform completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        FM_WEB_STRONGSELF(weakSelf)
        
        strongSelf.fm_downloadError = error;
        ///加载完成后 储存downloadImageURL
        [strongSelf setFm_imageLoadedURL:downLoadImageURLString];
        if (!error && image&&stage==YYWebImageStageFinished) {
            strongSelf.fm_requestState = FM_WebImageDownloadSucceed;
        }
        else {
            NSLog(@"error = %@  url:%@  self%p", error,url ,self);
            if (stage==YYWebImageStageFinished) {//YYImage请求未完成被取消,返回error=null
                strongSelf.fm_requestState = FM_WebImageDownloadFailed;
            }
            
        }
        //        [strongSelf fm_setupTapGesture];
        if (strongSelf.fm_downloadComplete) {
            strongSelf.fm_downloadComplete(strongSelf,image);
            //            [self fm_setShowContentMode:[self fm_failureContentMode] andImage:[self fm_getFailureImage]];
            [self setImage:[self fm_getFailureImage] forState:state];
        }
        if (completion) {
            completion(image, url, from, stage, error);
        }
        
    }];
    
}
//添加一个显示动画。。
//- (void)fm_setShowContentMode:(UIViewContentMode)showContentMode andImage:(UIImage*)image
//{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionFade;
//    [self.layer addAnimation:transition forKey:@"fmWebImageFade"];
//    if (self.contentMode != showContentMode) {
//        self.image = nil;
//        self.contentMode = showContentMode;
//        self.image = image;
//        [self setNeedsDisplay];
//    }
//    else if (self.image != image) {
//        self.image = image;
//    }
//}


@end
@implementation UIButton (FMTrans)

#pragma mark  main imageUrl setting method

//七牛的格式转换
- (NSString *)fm_mainSetImageURL:(id)URL forState:(UIControlState)state  shouldChangeQuality:(NSInteger)quality shouldChangeSize:(CGSize)changeSize shouldChangeImageType:(FM_QiNiu_ImageType)imageType
{
    NSString* downLoadImageURLString = nil;
    if ([URL isKindOfClass:[NSString class]]) {
        NSURL *imageURL = [NSURL URLWithString:URL];
        if (imageURL == nil){
            NSString* utf8String = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (utf8String != nil) {
                imageURL = [NSURL URLWithString:utf8String];
            }
        }
        downLoadImageURLString = [imageURL absoluteString];
    }
    else if ([URL isKindOfClass:[NSURL class]]) {
        downLoadImageURLString = [URL absoluteString];
    }
    
    //控件中只负责撸进去图片的尺寸，和图片格式
    if (CGSizeEqualToSize(changeSize, CGSizeZero)) {
        downLoadImageURLString =[NSString qiniuURL:downLoadImageURLString resize:CGSizeZero quality:quality type:FM_QiNiu_None];
    }
    else
    {
        downLoadImageURLString =[NSString qiniuURL:downLoadImageURLString resize:changeSize quality:quality type:FM_QiNiu_None];
    }
    if (imageType) {
        downLoadImageURLString =[NSString qiniuURL:downLoadImageURLString resize:CGSizeZero quality:quality type:imageType];
    }
    //
    
    return  downLoadImageURLString;
}


#pragma mark  factory method
#pragma image

- (void)fm_setImageWithURL:(id)url forState:(UIControlState)state
{
    [self fm_setImageWithURL:url forState:state placeholderImage:nil];
}
- (void)fm_setImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(NSString *)placeholder
{
    [self fm_setImageWithURL:url forState:state placeholderImage:placeholder failureImage:placeholder];
}
- (void)fm_setImageWithURL:(id)URL forState:(UIControlState)state placeholderImage:(NSString *)placeHodler failureImage:(NSString*)failureImage
{
    CGSize tempSize=self.bounds.size;
    CGFloat  s= [UIScreen mainScreen].scale;
    tempSize.height*=s;
    tempSize.width*=s;
    [self fm_org_setImageWithURL:URL forState:state placeholder:placeHodler failureImage:failureImage quality:100 size:tempSize imageType:FM_QiNiu_WEBP options:0 progress:nil transform:nil completion:nil];
}

- (void)fm_setOriginalImageURL:(id)URL forState:(UIControlState)state
{
    [self fm_setOriginalImageURL:URL forState:state type:FM_QiNiu_None];
}

- (void)fm_setOriginalImageURL:(id)URL forState:(UIControlState)state type:(FM_QiNiu_ImageType)type
{
    [self fm_setImageWithURL:URL forState:state resize:CGSizeZero type:type];
}

- (void)fm_setImageWithURL:(id)URL forState:(UIControlState)state resize:(CGSize)size
{
    [self fm_setImageWithURL:URL forState:state resize:size type:FM_QiNiu_WEBP];
}
- (void)fm_setImageWithURL:(id)URL forState:(UIControlState)state resize:(CGSize)size type:(FM_QiNiu_ImageType)type
{
    [self fm_org_setImageWithURL:URL forState:state placeholder:nil failureImage:nil quality:100 size:size imageType:type options:0 progress:nil transform:nil completion:nil];
}




#pragma mark backgroundImage
- (void)fm_setBackgroundImageWithURL:(id)url forState:(UIControlState)state
{
    [self fm_setImageWithURL:url forState:state placeholderImage:nil];
}
- (void)fm_setBackgroundImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(NSString *)placeholder
{
    [self fm_setImageWithURL:url forState:state placeholderImage:placeholder failureImage:placeholder];
}
- (void)fm_setBackgroundImageWithURL:(id)URL forState:(UIControlState)state placeholderImage:(NSString *)placeHodler failureImage:(NSString*)failureImage
{
    CGSize tempSize=self.bounds.size;
    CGFloat  s= [UIScreen mainScreen].scale;
    tempSize.height*=s;
    tempSize.width*=s;
    [self fm_org_setBackGroundImageWithURL:URL forState:state placeholder:placeHodler failureImage:failureImage quality:100 size:tempSize imageType:FM_QiNiu_WEBP options:0 progress:nil transform:nil completion:nil];
}

- (void)fm_setOriginalBackGroundImageURL:(id)URL forState:(UIControlState)state
{
    [self fm_setOriginalBackGroundImageURL:URL forState:state type:FM_QiNiu_None];
}

- (void)fm_setOriginalBackGroundImageURL:(id)URL forState:(UIControlState)state type:(FM_QiNiu_ImageType)type
{
    [self fm_setBackgroundImageWithURL:URL forState:state resize:CGSizeZero type:type];
}

- (void)fm_setBackgroundImageWithURL:(id)URL forState:(UIControlState)state resize:(CGSize)size
{
    [self fm_setBackgroundImageWithURL:URL forState:state resize:size type:FM_QiNiu_WEBP];
}
- (void)fm_setBackgroundImageWithURL:(id)URL forState:(UIControlState)state resize:(CGSize)size type:(FM_QiNiu_ImageType)type
{
    [self fm_org_setBackGroundImageWithURL:URL forState:state placeholder:nil failureImage:nil quality:100 size:size imageType:type options:0 progress:nil transform:nil completion:nil];
}




- (void)fm_org_setImageWithURL:(id)imageURL
                      forState:(UIControlState)state
                   placeholder:(id)placeholder
                  failureImage:(id)failureholder
                       quality:(NSInteger)quality
                          size:(CGSize)size
                     imageType:(FM_QiNiu_ImageType)imageType
                       options:(YYWebImageOptions)options
                      progress:( YYWebImageProgressBlock)progress
                     transform:( YYWebImageTransformBlock)transform
                    completion:( YYWebImageCompletionBlock)completion
{
    self.fm_failureImageName=placeholder;
    self.fm_placeholderImageName=failureholder;
    NSString *url=   [self fm_mainSetImageURL:imageURL forState:state shouldChangeQuality:quality shouldChangeSize:size shouldChangeImageType:imageType ];
    if ([NSThread isMainThread]) {
        [self fm_privateMainThreadDownloadURL:url forState:state options:options progress:progress transform:transform completion:completion];
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self fm_privateMainThreadDownloadURL:url forState:state options:options progress:progress transform:transform completion:completion];
        });
    }
    
}
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
                              completion:( YYWebImageCompletionBlock)completion
{
    self.fm_failureImageName=placeholder;
    self.fm_placeholderImageName=failureholder;
    NSString *url=  [self fm_mainSetImageURL:imageURL forState:state shouldChangeQuality:quality shouldChangeSize:size shouldChangeImageType:imageType];
    if ([NSThread isMainThread]) {
        [self fm_privateMainThreadBackGroundDownloadURL:url forState:state options:options progress:progress transform:transform completion:completion];
    }
    else {
        [self fm_privateMainThreadBackGroundDownloadURL:url forState:state options:options progress:progress transform:transform completion:completion];
    }
    
}

@end
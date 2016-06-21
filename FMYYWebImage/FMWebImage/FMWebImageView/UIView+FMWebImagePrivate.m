//
//  UIView+FMWebImagePrivate.m
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/20.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#import "UIView+FMWebImagePrivate.h"
#import <objc/runtime.h>

@implementation UIView (FMWebImagePrivate)

#pragma mark property
-(FM_WebImageState)fm_requestState
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
-(void)setFm_requestState:(FM_WebImageState)fm_requestState
{
    objc_setAssociatedObject(self, @selector(fm_requestState), @(fm_requestState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CGFloat)fm_downloadProgress
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
-(void)setFm_downloadProgress:(CGFloat)fm_downloadProgress
{
    objc_setAssociatedObject(self, @selector(fm_downloadProgress), @(fm_downloadProgress), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)fm_setup
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setFm_setup:(BOOL)fm_setup
{
    objc_setAssociatedObject(self, @selector(fm_setup), @(fm_setup), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSError *)fm_downloadError
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setFm_downloadError:(NSError *)fm_downloadError
{
    objc_setAssociatedObject(self, @selector(fm_downloadError), fm_downloadError, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (NSMutableDictionary *)fm_backGroundColorForRequestStateDict
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setFm_backGroundColorForRequestStateDict:(NSMutableDictionary *)fm_backGroundColorForRequestStateDict
{
    objc_setAssociatedObject(self, @selector(fm_backGroundColorForRequestStateDict), fm_backGroundColorForRequestStateDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)setFm_downloadComplite:(void (^)(UIView *, UIImage *))fm_downloadComplite
{
    objc_setAssociatedObject(self, @selector(fm_downloadComplite), fm_downloadComplite, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void (^)(UIView *, UIImage *))fm_downloadComplite
{
    return objc_getAssociatedObject(self, _cmd);
}

- (BOOL)fm_tapRetry
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setFm_tapRetry:(BOOL)fm_tapRetry
{
    objc_setAssociatedObject(self, @selector(fm_tapRetry), @(fm_tapRetry), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)setFm_progressView:(CALayer<FMWebProgressViewProtocol> *)fm_progressView
{
    objc_setAssociatedObject(self, @selector(fm_progressView), fm_progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CALayer<FMWebProgressViewProtocol>  *)fm_progressView
{
    return objc_getAssociatedObject(self, _cmd);
}


- (NSString  *)fm_imageLoadedURL
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setFm_imageLoadedURL:(NSString *)fm_imageLoadedURL
{
    objc_setAssociatedObject(self, @selector(fm_imageLoadedURL), fm_imageLoadedURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString  *)fm_failureImageName
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setFm_failureImageName:(NSString *)fm_failureImageName
{
    objc_setAssociatedObject(self, @selector(fm_failureImageName), fm_failureImageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString  *)fm_placeholderImageName{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setFm_placeholderImageName:(NSString *)fm_placeholderImageName
{
    objc_setAssociatedObject(self, @selector(fm_placeholderImageName), fm_placeholderImageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)fm_showProgress
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setFm_showProgress:(BOOL)fm_showProgress
{
    objc_setAssociatedObject(self, @selector(fm_showProgress), @(fm_showProgress), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end

@implementation UIView(FMWebImage)
+ (void)load
{
    [UIView webimage_swizzleMethod:@selector(setFm_requestState:) withMethod:@selector(aop_setFm_requestState:) error:nil];
    [UIView webimage_swizzleMethod:@selector(setFm_downloadProgress:) withMethod:@selector(aop_setFm_downloadProgress:) error:nil];
    [UIView webimage_swizzleMethod:@selector(setFm_showProgress:) withMethod:@selector(aop_setFm_showProgress:) error:nil];
}


#pragma mark

-(void)aop_setFm_requestState:(FM_WebImageState)webImageState
{
    [self aop_setFm_requestState:webImageState];
    self.fm_progressView.hidden = (webImageState != FM_WebImageDownloading);
    [self fm_overrideRequestStateChange:webImageState];
}
//need override
-(void)fm_overrideRequestStateChange:(FM_WebImageState)webImageState
{
    
}
#pragma mark download progressView
//override
-(void)fm_setProgressViewAccessory:(CALayer<FMWebProgressViewProtocol> *)progressView
{
    [self.fm_progressView removeFromSuperlayer];
    self.fm_progressView=nil;
    if (!self.fm_progressView) {
        self.fm_progressView=progressView;
        [self.layer addSublayer:progressView];
        self.fm_showProgress=YES;
    }
}
-(void)aop_setFm_downloadProgress:(CGFloat)dowloadProgress
{
    [self aop_setFm_downloadProgress:dowloadProgress];
    [self observer_downloadProgress];
}
- (void)observer_downloadProgress
{
    CALayer<FMWebProgressViewProtocol> *progressView = self.fm_progressView;
    ///当没有进度条时 取消下面的代码判断
    if (progressView == nil||progressView.superlayer==nil)
    {
        return;
    }
    CGFloat progress = self.fm_downloadProgress;
    [progressView fm_webImageProgressViewSetProgress:progress animated:YES];
}

-(void)aop_setFm_showProgress:(BOOL)showProgress
{
    [self aop_setFm_showProgress:showProgress];

}
#pragma mark placeholder

- (UIImage *)fm_getPlaceholderImage
{
    if (self.fm_showProgress) {
        return nil;
    }
    NSString* imageName = self.fm_placeholderImageName;
    if (imageName == nil) {
        
        imageName = [[FMWebImageManager shareInstance] fm_getPlaceholderImageNameFromArrayBySize:self.bounds.size];
        self.fm_placeholderImageName = imageName;
    }
    if (imageName) {
        return [UIImage imageNamed:imageName];
    }
    return nil;
    
}

- (UIImage *)fm_getFailureImage
{
    NSString* imageName = self.fm_failureImageName;
    if (imageName == nil) {
        imageName = [[FMWebImageManager shareInstance]fm_getFailureImageNameFromArrayBySize:self.bounds.size];
        self.fm_failureImageName = imageName;
    }
    if (imageName) {
        return [UIImage imageNamed:imageName];
    }
    return nil;
}



@end

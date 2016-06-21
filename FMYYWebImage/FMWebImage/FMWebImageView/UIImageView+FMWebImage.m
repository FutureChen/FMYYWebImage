//
//  UIImageView+FMWebImage.m
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/15.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#import "UIImageView+FMWebImage.h"
#import <objc/runtime.h>
#import "FMWebImageManager.h"
#import "UITapGestureRecognizer+FMWeb.h"
#import "UIImageView+YYWebImage.h"
//#define FMImageViewFixTag (100)


NSInteger const FM_WEBIMAGE_CONTENTMODE_FIX_TAG =100 ;//因为要设置fm_orginalContentMode= 系统的uiviewContentModel,所以引入tag值做区分原始的cotentModel

@interface UIImageView (FM_WebImage_Private)

@property (nonatomic,assign) UIViewContentMode fm_orginalContentMode; //图片原始的contentMode== 图片下载成功的时候的显示模式
@property (nonatomic,assign) UIViewContentMode fm_downloadContentMode; //必须在下载方法之前赋值
@property (nonatomic,assign) UIViewContentMode fm_failureContentMode;


@property(strong, nonatomic) UITapGestureRecognizer *originalTap;////图片下载失败的时候，会用重新载入手势，覆盖图片原有的点击手势，这个作为临时变量存储
@property(strong, nonatomic) UITapGestureRecognizer *failureTap;
@property(assign, nonatomic) BOOL fm_originalUserInteractionEnabled;


@end
@implementation UIImageView(FM_WebImage_Private)

#pragma mark ---------- property ————

-(UIViewContentMode)fm_orginalContentMode
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
-(void)setFm_orginalContentMode:(UIViewContentMode)fm_orginalContentMode
{
    objc_setAssociatedObject(self, @selector(fm_orginalContentMode), @(fm_orginalContentMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIViewContentMode)fm_failureContentMode
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
-(void)setFm_failureContentMode:(UIViewContentMode)fm_failureContentMode
{
    objc_setAssociatedObject(self, @selector(fm_failureContentMode), @(fm_failureContentMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIViewContentMode)fm_downloadContentMode
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
-(void)setFm_downloadContentMode:(UIViewContentMode)fm_downloadContentMode
{
    objc_setAssociatedObject(self, @selector(fm_downloadContentMode), @(fm_downloadContentMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(UITapGestureRecognizer *)originalTap
{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setOriginalTap:(UITapGestureRecognizer *)originalTap
{
    objc_setAssociatedObject(self, @selector(originalTap), originalTap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UITapGestureRecognizer *)failureTap
{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setFailureTap:(UITapGestureRecognizer *)failureTap
{
    objc_setAssociatedObject(self, @selector(failureTap), failureTap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)fm_originalUserInteractionEnabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setFm_originalUserInteractionEnabled:(BOOL)fm_originalUserInteractionEnabled
{
    objc_setAssociatedObject(self, @selector(fm_originalUserInteractionEnabled), @(fm_originalUserInteractionEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}




@end

@implementation UIImageView (FMWebImage)


#pragma mark ---------- life cycle ----------
+ (void)load
{
    [UIImageView webimage_swizzleMethod:@selector(initWithFrame:) withMethod:@selector(aop_initWithFrame:) error:nil];
    [UIImageView webimage_swizzleMethod:@selector(initWithCoder:) withMethod:@selector(aop_initWithCoder:) error:nil];
    [UIImageView webimage_swizzleMethod:@selector(layoutSubviews) withMethod:@selector(aop_layoutSubviews) error:nil];
    [UIImageView webimage_swizzleMethod:@selector(setContentMode:) withMethod:@selector(aop_setContentMode:) error:nil];
    [UIImageView webimage_swizzleMethod:@selector(addGestureRecognizer:) withMethod:@selector(aop_addGestureRecognizer:) error:nil];
    [UIImageView webimage_swizzleMethod:@selector(setUserInteractionEnabled:) withMethod:@selector(aop_setUserInteractionEnabled:) error:nil];

    //    [UIImageView webimage_swizzleMethod:@selector(setBackgroundColor:) withMethod:@selector(FMweb_setBackgroundColor:) error:nil];
}
- (instancetype)aop_initWithFrame:(CGRect)frame
{
    UIImageView* imageView = [self aop_initWithFrame:frame];
    [self aop_initBuilder:imageView];
    return imageView;
}
- (instancetype)aop_initWithCoder:(NSCoder *)coder
{
    UIImageView* imageView = [self aop_initWithCoder:coder];
    [self aop_initBuilder:imageView];
    return imageView;
}
-(void)aop_initBuilder:(UIImageView*)imageView
{
    //初始化一些默认状态
    imageView.fm_failureContentMode = UIViewContentModeCenter+FM_WEBIMAGE_CONTENTMODE_FIX_TAG;
    imageView.fm_downloadContentMode = UIViewContentModeCenter+FM_WEBIMAGE_CONTENTMODE_FIX_TAG;
    [imageView fm_setBackGroundColor:FM_WEB_SUCCESS_BACKGROUNDCOLOR forRequestState:FM_WebImageDownloadSucceed];
//   UIViewContentMode mode= imageView.fm_orginalContentMode = imageView.contentMode+FM_WEBIMAGE_CONTENTMODE_FIX_TAG;
}

- (void)aop_layoutSubviews
{
    [self aop_layoutSubviews];
    //    if (self.fm_setup)
    //    {
    //        if (self.backGroundColorForRequestStateDict) {
    //            NSString *key=  FM_WebImageStateString(self.webImageState);
    //            UIColor *color=   [self.backGroundColorForRequestStateDict objectForKey:key];
    //            if (color) {
    //                [self setBackgroundColor:color];
    //            }
    //            else
    //            {
    //                NSString *key=   FM_WebImageStateString(FM_WebImageDownloadSucceed);
    //                UIColor *color=   [self.backGroundColorForRequestStateDict objectForKey:key];
    //                [self setBackgroundColor:color];
    //            }
    //        }
    //        else
    //        {
    //            [self setBackgroundColor:FM_WEB_DEFAULT_BACKGROUNDCOLOR];//默认背景颜色
    //        }
    //
    //    }
}



/**
 *   设置默认值contentMode
 *
 *  @param contentMode <#contentMode description#>
 */
-(void)aop_setContentMode:(UIViewContentMode)contentMode
{
  
    UIViewContentMode mode = contentMode;
    if ((NSInteger) contentMode < FM_WEBIMAGE_CONTENTMODE_FIX_TAG) {//如果是调用系统的方法，赋值的UIViewContentMode值小于TAG值
        self.fm_orginalContentMode = contentMode+FM_WEBIMAGE_CONTENTMODE_FIX_TAG;
    }
    else {//如果是框架内的fm_downloadContentMode、FM_WebImageDownloadSucceed等，都添加了TAG值，要还原成系统的值
        mode = contentMode - FM_WEBIMAGE_CONTENTMODE_FIX_TAG;
    }
      NSLog(@" state%ld  contentModel%ld %@  self %p",self.fm_requestState,contentMode,self.fm_imageLoadedURL,self);
    [self aop_setContentMode:mode];
}





#pragma mark  while request state change, setting self some property
///根据请求状态的不同，返回不同的contentMode
- (UIViewContentMode)fm_GetcontentModeByRequestState
{
    switch (self.fm_requestState)
    {
        case FM_WebImageDownloading:
        {
            return self.fm_downloadContentMode;
        }
        case FM_WebImageDownloadFailed:
        {
            return self.fm_failureContentMode;
        }
        default:
        {
            UIViewContentMode mode= self.fm_orginalContentMode;
            return mode;
        }
    }
}
-(void)fm_setContentMode:(UIViewContentMode)contentMode forRequestState:(FM_WebImageState)requestState
{
    switch (requestState) {
        case FM_WebImageDownloading:
        {
            self.fm_downloadContentMode=contentMode+FM_WEBIMAGE_CONTENTMODE_FIX_TAG;
        }
            break;
        case FM_WebImageDownloadSucceed:
        {
            self.fm_orginalContentMode=contentMode+FM_WEBIMAGE_CONTENTMODE_FIX_TAG;
        }
            break;
        case FM_WebImageDownloadFailed:
        {
            self.fm_failureContentMode=contentMode+FM_WEBIMAGE_CONTENTMODE_FIX_TAG;
        }
            break;
        default:
            break;
    }
}
-(void)fm_overrideRequestStateChange:(FM_WebImageState)webImageState
{
    //change backgroundColor
    if (self.fm_backGroundColorForRequestStateDict) {
        NSString *key=  FM_WebImageStateString(webImageState);
        UIColor *color=   [self.fm_backGroundColorForRequestStateDict objectForKey:key];
        if (color) {
            [self setBackgroundColor:color];
        }
        else
        {
            [self setBackgroundColor:FM_WEB_DEFAULT_BACKGROUNDCOLOR];//默认背景颜色
        }
    }
    
    //change displayContentMode
    UIViewContentMode mode=[self fm_GetcontentModeByRequestState];
    self.contentMode=mode;

}

//添加一个显示动画。。
- (void)fm_setShowContentMode:(UIViewContentMode)showContentMode andImage:(UIImage*)image
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.layer addAnimation:transition forKey:@"fmWebImageFade"];
    if (self.contentMode != showContentMode) {
        self.image = nil;
        self.contentMode = showContentMode;
        self.image = image;
        [self setNeedsDisplay];
    }
    else if (self.image != image) {
        self.image = image;
    }
}







#pragma mark   tapGuest
-(void)aop_addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[FMTapGestureRecognizer class]]) {//用fmFMTapGestureRecognizer 来区分是业务逻辑的点击手势，还是框架的重新加载图片手势
        self.originalTap = (UITapGestureRecognizer *) gestureRecognizer;
    }
    [self aop_addGestureRecognizer:gestureRecognizer];
}

-(void)aop_setUserInteractionEnabled:(BOOL)enable
{
    self.fm_originalUserInteractionEnabled = enable;
    [self aop_setUserInteractionEnabled:enable];
}

- (void)fm_setupTapGesture
{
    if (self.fm_tapRetry) {
        [self _fmSetUserInteractionEnabled:self.fm_originalUserInteractionEnabled];
        if (self.originalTap) {
            [self addGestureRecognizer:self.originalTap];
        }
        return;
    }
    [self removeGestureRecognizer:self.failureTap];
    [self removeGestureRecognizer:self.originalTap];
    if (self.fm_requestState == FM_WebImageDownloadSucceed)
    {
        [self _fmSetUserInteractionEnabled:self.fm_originalUserInteractionEnabled];
        if (self.originalTap) {
            [self addGestureRecognizer:self.originalTap];
        }
    }
    else if (self.fm_requestState == FM_WebImageDownloadFailed)
    {
        //        NSError *error=self.downloadError;
        BOOL is404 = self.fm_downloadError.code == 404;
        BOOL isNetworkEnable = ([FMWebImageManager shareInstance].s_imageNetworkType != FMImageNetworkTypeNone);
        BOOL is0px = [self.fm_downloadError.localizedDescription isEqualToString:@"Downloaded image has 0 pixels"];
        //        BOOL isNilUrl=[self.downloadError.localizedDescription isEqualToString:@"Trying to load a nil url"];
        if (is404 || !isNetworkEnable || is0px)
        {
            [self _fmSetUserInteractionEnabled:self.fm_originalUserInteractionEnabled];
            if (self.originalTap) {
                [self addGestureRecognizer:self.originalTap];
            }
        }
        else
        {
            [self _fmSetUserInteractionEnabled:YES];
            [self addGestureRecognizer:self.failureTap];
        }
    }
    else if (self.fm_requestState == FM_WebImageDownloading)
    {
        [self _fmSetUserInteractionEnabled:self.fm_originalUserInteractionEnabled];
        if (self.originalTap) {
            [self addGestureRecognizer:self.originalTap];
        }
    }
}

- (void)_fmSetUserInteractionEnabled:(BOOL)enable
{
    [super setUserInteractionEnabled:enable];
}



-(void)fm_setBackGroundColor:(UIColor *)color forRequestState:(FM_WebImageState)state;
{
    if (color) {
        if (!self.fm_backGroundColorForRequestStateDict) {
            self.fm_backGroundColorForRequestStateDict=[NSMutableDictionary new];
        }
        NSString *key=FM_WebImageStateString(state);
        [self.fm_backGroundColorForRequestStateDict setObject:color forKey:key];
    }
}
#pragma mark main download method
///保证在主线程运行 就可以不用加锁了
- (void)fm_privatePrepareDownload
{
    if (!self.fm_setup)
    {
        self.fm_setup = YES;
        FM_WEB_WEAKSELF
        self.failureTap = [[FMTapGestureRecognizer alloc]initWithActionBlock:^(id sender) {
            if (self.fm_requestState == FM_WebImageDownloadFailed) {
                [weakSelf fm_setImageWithURL:weakSelf.yy_imageURL];
            }
        }];
        //self.displayContentMode = self.contentMode;//这里存在问题，这里存储了图片原有的contentMode  但是如果图片加载失败过一次，这里存储的是失败时候修改的状态，移动代码的位置到init里去了
        NSUInteger index = [self.gestureRecognizers indexOfObjectPassingTest:^BOOL(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj isKindOfClass:[UITapGestureRecognizer class]];
        }];
        if (index==NSNotFound) {
            self.originalTap=nil;
        }
        else
        {
            self.originalTap= [self.gestureRecognizers  objectAtIndex:index];
        }
    }
    
    
    self.fm_downloadError = nil;
    [self setFm_imageLoadedURL:nil];
//    [self yy_cancelCurrentImageRequest];
    self.fm_requestState = FM_WebImageDownloading;
    self.fm_downloadProgress = 0;
    
    [self fm_setupTapGesture];
}



- (void)fm_privateMainThreadDownloadURL:(NSString*)downLoadImageURLString options:(YYWebImageOptions)options progress:(nullable YYWebImageProgressBlock)progress
                              transform:(nullable YYWebImageTransformBlock)transform
                             completion:(nullable YYWebImageCompletionBlock)completion
{
    
    if ([self.fm_imageLoadedURL isEqualToString:downLoadImageURLString] && self.image && self.fm_requestState == FM_WebImageDownloadSucceed) {
        ///url 相同并且有图片 就不去走下载图片的流程  ,同一张图，置空，重新再下，这个判断会出问题
        //        self.fm_downloadComplite(self.image);
        //        return;
    }
    
    
    ///正式开始下载
    [self fm_privatePrepareDownload];
    
    FM_WEB_WEAKSELF
    NSLog(@"______________________________________________%@",downLoadImageURLString);
    [self yy_setImageWithURL:[NSURL URLWithString:downLoadImageURLString] placeholder:[self fm_getPlaceholderImage] options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
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
            if (YYWebImageStageFinished) {//YYImage请求未完成被取消,返回error=null，要用这个状态进行判断，fuck!!!
               strongSelf.fm_requestState = FM_WebImageDownloadFailed;
            }
            //被取消的状态下，保持loading状态不变，所以略..
         
        }
        [strongSelf fm_setupTapGesture];
        if (strongSelf.fm_downloadComplite) {
            strongSelf.fm_downloadComplite(strongSelf,image);
            [self fm_setShowContentMode:self.fm_failureContentMode andImage:[self fm_getFailureImage]];
        }
        if (completion) {
            completion(image, url, from, stage, error);
        }
    }];
    
}

#pragma mark ---------- event respone ----------

















@end

@implementation UIImageView (FMTrans)

#pragma mark  main imageUrl setting method
//static float systemValue=1;
//七牛的格式转换
- (void)fm_mainSetImageURL:(id)URL shouldChangeQuality:(NSInteger)quality shouldChangeSize:(CGSize)changeSize shouldChangeImageType:(FM_QiNiu_ImageType)imageType options:(YYWebImageOptions)options progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion
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
    if (options==0) {
            options=FMWeb_DefaultOptions;
//            static dispatch_once_t onceToken;
//            dispatch_once(&onceToken, ^{
//                if (([UIDevice currentDevice].systemVersion.floatValue <= 8)) {
//                    systemValue=0;
//                }
//            });
//            if (systemValue==0)//8以下的系统
//            {
//                if ([downLoadImageURLString rangeOfString:@".gif"].location!=NSNotFound) {
//                    options=FMWeb_GifOptions;
//                }
//                
//            }
//            else
//            {
//                if ([downLoadImageURLString containsString:@".gif"]) {
//                    options=FMWeb_GifOptions;
//                }
//                
//            }
        }
    
    if ([NSThread isMainThread]) {
        [self fm_privateMainThreadDownloadURL:downLoadImageURLString options:options progress:progress transform:transform completion:completion];
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self fm_privateMainThreadDownloadURL:downLoadImageURLString options:options progress:progress transform:transform completion:completion];
        });
    }
}


#pragma mark  factory method

- (void)fm_setImageWithURL:(id)URL
{
    [self fm_setImageWithURL:URL placeholderImage:nil failureImage:nil];
    
}
- (void)fm_setImageWithURL:(id)URL placeholderImage:(NSString *)placeHodler
{
    [self fm_setImageWithURL:URL placeholderImage:placeHodler failureImage:placeHodler];
}
- (void)fm_setImageWithURL:(id)URL placeholderImage:(NSString *)placeHodler failureImage:(NSString*)failureImage
{
    CGSize tempSize=self.bounds.size;
    CGFloat  s= [UIScreen mainScreen].scale;
    tempSize.height*=s;
    tempSize.width*=s;
    
    [self fm_org_setImageWithURL:URL placeholder:placeHodler failureImage:failureImage quality:100 size:tempSize imageType:FM_QiNiu_WEBP options:0 progress:nil transform:nil completion:nil];
}

- (void)fm_setOriginalImageURL:(id)URL
{
    [self fm_setOriginalImageURL:URL type:FM_QiNiu_None];
}

- (void)fm_setOriginalImageURL:(id)URL type:(FM_QiNiu_ImageType)type
{
    [self fm_setImageWithURL:URL resize:CGSizeZero type:type];
}

- (void)fm_setImageWithURL:(id)URL resize:(CGSize)size
{
    [self fm_setImageWithURL:URL resize:size type:FM_QiNiu_WEBP];
}
- (void)fm_setImageWithURL:(id)URL resize:(CGSize)size type:(FM_QiNiu_ImageType)type
{
    [self fm_org_setImageWithURL:URL placeholder:nil failureImage:nil quality:100 size:size imageType:type options:0 progress:nil transform:nil completion:nil];
}





- (void)fm_org_setImageWithURL:(id)imageURL
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
    [self fm_mainSetImageURL:imageURL shouldChangeQuality:quality shouldChangeSize:size shouldChangeImageType:imageType options:options progress:progress transform:transform completion:completion];
}


@end


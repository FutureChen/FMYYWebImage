//
//  UIView+FMWebImagePrivate.h
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/20.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMWebProgressViewProtocol.h"
#import "FMWebImagePrefix.h"
#import "FMWebImageManager.h"

#define FM_WEB_DEFAULT_BACKGROUNDCOLOR [UIColor redColor]
#define FM_WEB_SUCCESS_BACKGROUNDCOLOR [UIColor greenColor]


@interface UIView (FMWebImagePrivate)
#pragma mark private
//UIButton 和UIImageView 公用的参数
@property (nonatomic,assign) FM_WebImageState fm_requestState;
@property (strong,nonatomic) CALayer<FMWebProgressViewProtocol> *fm_progressView;
@property (nonatomic,assign) CGFloat fm_downloadProgress;
///如果显示进度条，下载的时候不显示palceholder 只有失败的时候显示failureImage
@property (nonatomic,assign) BOOL fm_showProgress;
@property (nonatomic,assign) BOOL fm_setup;
@property (strong, nonatomic) NSError *fm_downloadError;
///存储背景颜色的字典
@property (nonatomic,strong) NSMutableDictionary *fm_backGroundColorForRequestStateDict;


@end






#pragma mark public
/**
 *  嵌入占位图、加载进度条、加载失败点击重试 等业务功能
 */
@interface UIView (FMWebImage)

//必须在调用方法之前设置，否则无效
@property(nonatomic,copy)  void(^fm_downloadComplite)(UIView *imageView,UIImage * image);

@property(copy, nonatomic) NSString *fm_placeholderImageName; /**< 默认占位图请用 FM_addPlaceholderImageName:*/
@property(copy, nonatomic) NSString *fm_failureImageName;  /**< 默认失败图请用 FM_addFailureImageName:*/
///加载完成的图片URL地址
@property(copy,nonatomic)  NSString *fm_imageLoadedURL;

///开启点击重新加载的功能 default is close
@property(nonatomic,assign)BOOL fm_tapRetry;
//设置进入条视图
-(void)fm_setProgressViewAccessory:(CALayer<FMWebProgressViewProtocol> *)progressView;


///获取控件实际调用的占位图
- (UIImage *)fm_getPlaceholderImage;
- (UIImage *)fm_getFailureImage;
@end
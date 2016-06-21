//
//  FMWebImageManager.h
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/15.
//  Copyright © 2016年 陈炜来. All rights reserved.
//  模块独立化，所以不引入无谓的框架和网络监听，只提供可修改的参数。  其他具体逻辑可以引出BLL

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSObject+FMWebPrivate.h"


typedef NS_ENUM(NSInteger, FMImageNetworkType)
{
    FMImageNetworkTypeNone = 0,
    FMImageNetworkTypeWWAN = 1,
    FMImageNetworkTypeWIFI = 2
};
@interface FMWebImageManager : NSObject
+ (instancetype)shareInstance;


///网络状态 设置以后加载图片的质量会受影响
@property (nonatomic,assign)FMImageNetworkType s_imageNetworkType;

///蜂窝数据下七牛的低质量图片参数，默认值为 30 ，取值范围 （0，100）
@property (nonatomic,assign)NSInteger s_qiniuImageQuality;

///是否在蜂窝数据下自动改变图片的质量，默认开启
@property (nonatomic,assign)BOOL s_qiniuQualityAutoChange;


/**
 *  设置全局的占位图，如果没有设置placeholderImageName，则会自动从数组里面寻找适合自己的尺寸占位图
 */
-(void)fm_addPlaceholderImageName:(NSString*)imageName;
-(void)fm_addFailureImageName:(NSString*)imageName;
/**
 *  根据size从全局的占位图数组中撸出最适合的图
 */
-(NSString *)fm_getPlaceholderImageNameFromArrayBySize:(CGSize)size;
-(NSString *)fm_getFailureImageNameFromArrayBySize:(CGSize)size;
-(void)fm_array:(NSMutableArray*)array addImageName:(NSString*)imageName;






@end


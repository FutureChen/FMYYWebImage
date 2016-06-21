//
//  FMWebImagePrefix.h
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/20.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#ifndef FMWebImagePrefix_h
#define FMWebImagePrefix_h


#import "YYWebImageManager.h"


#define fm_web_dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define FM_WEB_WEAKSELF      __weak typeof(self) weakSelf                    = self;
#define  FM_WEB_STRONGSELF(weakSelf)    __strong __typeof(weakSelf)strongSelf = weakSelf;

typedef NS_ENUM(NSInteger, FM_WebImageState)
{
    FM_WebImageDownloading = 0,
    FM_WebImageDownloadSucceed=1,
    FM_WebImageDownloadFailed=2,
};

//根据请求的结果状态返回字符串
static inline NSString *FM_WebImageStateString(FM_WebImageState state) {
    NSString *ret =@"";
    switch (state) {
        case FM_WebImageDownloading:
        {
            ret=@"FM_WebImageDownloading";
        }
            break;
        case FM_WebImageDownloadSucceed:
        {
            ret=@"FM_WebImageDownloadSucceed";
        }
            break;
        case FM_WebImageDownloadFailed:
        {
            ret=@"FM_WebImageDownloadFailed";
        }
            break;
        default:
            ret=@"";
            break;
    }
    return ret;
}

static  YYWebImageOptions FMWeb_DefaultOptions=  YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation;
static  YYWebImageOptions FMWeb_GifOptions=  YYWebImageOptionProgressive | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation;


#endif /* FMWebImagePrefix_h */

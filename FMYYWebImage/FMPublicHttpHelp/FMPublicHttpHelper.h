//
//  FMPublicHttpHelper.h
//  FM_ViewKit
//
//  Created by ljh on 15/5/21.
//  Copyright (c) 2015年 FM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ReactiveCocoa.h>

extern NSString *const kFMNetworkChangedNotification;

@interface FMPublicHttpHelper : NSObject

///网络切换信息   0:无网络  1:WWAN  2:WIFI
+(RACSignal*)networkChangedSignal;
//
+ (BOOL)networkEnable; /**< 网络连接是否正常*/
//
+ (BOOL)isWiFi;/**< 当前网络是否WiFi*/
+ (BOOL)isWWAN;/**< 当前网络是否蜂窝数据*/
//
+ (BOOL)is2G;   /**< 当前为2G网络 IOS7之上才支持*/
+ (BOOL)is3G;   /**< 当前为3G网络 IOS7之上才支持*/
+ (BOOL)is4G;   /**< 当前为4G网络 IOS7之上才支持*/
//
+ (BOOL)isWiFiValid; /**< 判 断WiFi地址是否有效来判断当前使用的是不是WiFi*/



///当生成request时 调用  可以添加多个
//+(void)setAddHttpHeadersFromBlock:(NSDictionary*(^)(NSString* urlString))headerBlock;
//+(void)setAddHttpURLQueriesFromBlock:(NSDictionary*(^)(NSString* urlString))urlQueriesBlock;
//
/////是否美莓自己域名
+(BOOL)FM_isFMSite:(NSString *)urlString;
//
/////给web request添加请求头参数
+(void)addRequestHeadersToRequest:(NSMutableURLRequest *)urlRequest;
//
///根据URL返回要带上的参数
+(NSMutableDictionary*)urlQueryParameterWithURLString:(NSString*)urlString;
///根据URL返回要加上的请求头
+(NSMutableDictionary*)urlRequestHeadersWithURLString:(NSString*)urlString;

@end


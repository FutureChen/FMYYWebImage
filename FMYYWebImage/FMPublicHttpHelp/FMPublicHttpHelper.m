//
//  FMPublicHttpHelper.m
//  FM_ViewKit
//
//  Created by ljh on 15/5/21.
//  Copyright (c) 2015年 FM. All rights reserved.
//

#import "FMPublicHttpHelper.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//#import "UIDevice+FMPublic.h"

NSString *const kFMNetworkChangedNotification = @"kFMNetworkChangedNotification";

@interface FMPublicHttpHelper ()
@property(strong, nonatomic) NSMutableDictionary *hostTable;
@property(strong, nonatomic) NSRecursiveLock *lock;

@property(nonatomic, strong) NSMutableArray *headerBlockArray;
@property(nonatomic, strong) NSMutableArray *urlQueryBlockArray;

@property(strong, nonatomic) Reachability *reach;
@property(copy, nonatomic) NSString *localIP;

@property(strong, nonatomic) RACSignal *networkChangedSignal;

@property(nonatomic) NSInteger currentRaioAccessType; /**< 当前的网络类别 0:无  2:2G  3:3G  4:4G */

@end

@implementation FMPublicHttpHelper
+ (void)load {
    [FMPublicHttpHelper globalReachability];
}

+ (Reachability *)globalReachability {
    static Reachability *reach = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reach = [Reachability reachabilityForInternetConnection];
        [reach startNotifier];
        [reach isReachable];
    });
    return reach;
}
+ (FMPublicHttpHelper *)shareHttpClient {
    static FMPublicHttpHelper *client;
    if (client) {
        return client;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [self alloc];
        client = [client init];
    });
    return client;
}

+ (RACSignal *)networkChangedSignal {
    return [self shareHttpClient].networkChangedSignal;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.headerBlockArray = [NSMutableArray array];
        self.urlQueryBlockArray = [NSMutableArray array];

        self.hostTable = [NSMutableDictionary dictionary];
        self.lock = [[NSRecursiveLock alloc] init];

        self.networkChangedSignal = [RACSubject subject];
        self.reach = [FMPublicHttpHelper globalReachability];

        @weakify(self);
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kReachabilityChangedNotification object:nil]
                takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
            @strongify(self);
#warning need derelease
//            [UIDevice FM_clearNetworkStateString];
//            self.localIP = [[UIDevice currentDevice] FM_ipAddress];

            if (([UIDevice currentDevice].systemVersion.floatValue >= 7)) {
                CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
                [self checkCurrentRadioAccess:networkInfo.currentRadioAccessTechnology];
            }

            ///0无网络  1 WWAN  2 Wifi
            NSNumber *networkStatus = @(self.reach.currentReachabilityStatus);

            [[NSNotificationCenter defaultCenter] postNotificationName:kFMNetworkChangedNotification object:networkStatus];

            RACSubject *subject = (id) self.networkChangedSignal;
            [subject sendNext:networkStatus];
        }];

        if (([UIDevice currentDevice].systemVersion.floatValue >= 7)) {
            [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:CTRadioAccessTechnologyDidChangeNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *x) {
                @strongify(self);
                NSString *currentRadioAccessTechnology = [x object];
                [self checkCurrentRadioAccess:currentRadioAccessTechnology];
            }];
        }
    }
    return self;
}

- (void)checkCurrentRadioAccess:(NSString *)currentRadioAccessTechnology {
    self.currentRaioAccessType = 0;
    if (self.isWWAN) {
        if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
            self.currentRaioAccessType = 4;
        }
        else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
            self.currentRaioAccessType = 2;
        }
        else {
            self.currentRaioAccessType = 3;
        }
    }
}


- (BOOL)isWWAN {
    return self.reach.isReachableViaWWAN;
}

- (BOOL)isWiFi {
    return self.reach.isReachableViaWiFi;
}

- (BOOL)networkEnable {
    return self.reach.isReachable;
}

+ (BOOL)isWWAN {
    return [[self shareHttpClient] isWWAN];
}

+ (BOOL)isWiFi {
    return [[self shareHttpClient] isWiFi];
}
//
+ (BOOL)networkEnable {
//   return [[AFNetworkReachabilityManager sharedManager] isReachable];
    return [[self shareHttpClient] networkEnable];
}

+ (BOOL)isWiFiValid {
    if (([UIDevice currentDevice].systemVersion.floatValue >= 8)) {
        return [self isWiFi];
    }
    else {
        NSString *localIP = [self shareHttpClient].localIP;
        if (!localIP) {
#warning need derelease
//            localIP = [[UIDevice currentDevice] FM_ipAddress];
        }
        return (localIP && ![localIP isEqualToString:@"error"]);
    }
}

+ (BOOL)is2G {
    return ([self shareHttpClient].currentRaioAccessType == 2);
}

+ (BOOL)is3G {
    return ([self shareHttpClient].currentRaioAccessType == 3);
}

+ (BOOL)is4G {
    return ([self shareHttpClient].currentRaioAccessType == 4);
}
//
//- (FMHTTP *)httpWithHost:(NSString *)host {
//    if (host == nil) {
//        host = @"";
//    }
//    [_lock lock];
//
//    FMHTTP *http = _hostTable[host];
//    if (http == nil) {
//        http = [FMHTTP httpWithBaseURL:[NSURL URLWithString:host]];
//        [self didCreatedHttp:http host:host];
//        _hostTable[host] = http;
//    }
//
//    [_lock unlock];
//    return http;
//}

//+ (FMHTTP *)httpWithHost:(NSString *)host {
//    return [[self shareHttpClient] httpWithHost:host];
//}

+ (void)setAddHttpHeadersFromBlock:(NSDictionary *(^)(NSString *))headerBlock {
    if (headerBlock) {
        [[self shareHttpClient].headerBlockArray addObject:[headerBlock copy]];
    }
}

+ (void)setAddHttpURLQueriesFromBlock:(NSDictionary *(^)(NSString *))urlQueriesBlock {
    if (urlQueriesBlock) {
        [[self shareHttpClient].urlQueryBlockArray addObject:[urlQueriesBlock copy]];
    }
}

//- (void)didCreatedHttp:(FMHTTP *)http host:(NSString *)host {
//    @weakify(self);
//    [http setAddHttpURLQueriesFromBlock:^NSDictionary *(NSString *urlString, NSDictionary *currentQuery) {
//        @strongify(self);
//        return [self.class urlQueryParameterWithURLString:urlString.lowercaseString];
//    }];
//
//    [http setAddHttpHeadersFromBlock:^NSDictionary *(NSMutableURLRequest *request) {
//        @strongify(self);
//        [self.class addRequestHeadersToRequest:request];
//        return nil;
//    }];
//}

+ (NSMutableDictionary *)urlRequestHeadersWithURLString:(NSString *)urlString {
    return nil;
}

+ (NSMutableDictionary *)urlQueryParameterWithURLString:(NSString *)urlString {
    if (!urlString && ![FMPublicHttpHelper FM_isFMSite:urlString]) {
        return nil;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [[self shareHttpClient].urlQueryBlockArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *(^urlQueryBlock)(NSString *urlString) = obj;
        NSDictionary *customAddParams = urlQueryBlock(urlString);
        [params addEntriesFromDictionary:customAddParams];
    }];

    return params;
}

+ (BOOL)FM_isFMSite:(NSString *)urlString {
    BOOL isMyHost = NO;
//    NSString *host = [NSURL URLWithString:urlString.lowercaseString].host;
//    NSRange range=  [host rangeOfString:@"meimei"];
//    if (range.location!=NSNotFound) {
//        isMyHost =YES;
//    }

    isMyHost=YES;
    return isMyHost;
}

+ (void)addRequestHeadersToRequest:(NSMutableURLRequest *)urlRequest {
//    [urlRequest setValue:[FMToolsFunction getToken] forHTTPHeaderField:@"t"];
//    [urlRequest setValue:[FMToolsFunction FMHttpHeadDefaultString] forHTTPHeaderField:@"h"];

}

+ (NSMutableDictionary *)statInfo {
    return nil;
}
@end

@implementation FMPublicHttpHelper (FMHTTPRequest)
//+ (RACSignal *)getPath:(NSString *)path host:(NSString *)host params:(id)params {
//    return [self method:HttpGet path:path host:host params:params];
//}
//
//+ (RACSignal *)postPath:(NSString *)path host:(NSString *)host params:(id)params {
//    return [self method:HTTPPost path:path host:host params:params];
//}
//
//+ (RACSignal *)putPath:(NSString *)path host:(NSString *)host params:(id)params {
//    return [self method:HTTPPut path:path host:host params:params];
//}
//
//+ (RACSignal *)method:(HttpMethod)method path:(NSString *)path host:(NSString *)host params:(id)params {
//    FMHTTP *http = [self httpWithHost:host];
//    FMHTTPBuilder *builder = [FMHTTPBuilder new].METHOD(method).PATH(path).PARAMETERS(params);
//    return [http runWithBuilder:builder];
//}
//
//+ (AFHTTPRequestOperation *)getPath:(NSString *)path host:(NSString *)host params:(id)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
//    return [self method:HttpGet path:path host:host params:params success:success failure:failure];
//}
//
//+ (AFHTTPRequestOperation *)postPath:(NSString *)path host:(NSString *)host params:(id)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
//    return [self method:HTTPPost path:path host:host params:params success:success failure:failure];
//}
//
//+ (AFHTTPRequestOperation *)putPath:(NSString *)path host:(NSString *)host params:(id)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
//    return [self method:HTTPPut path:path host:host params:params success:success failure:failure];
//}
//
//+ (AFHTTPRequestOperation *)method:(HttpMethod)method path:(NSString *)path host:(NSString *)host params:(id)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
//    FMHTTP *http = [self httpWithHost:host];
//    FMHTTPBuilder *builder = [FMHTTPBuilder new].METHOD(method).PATH(path).PARAMETERS(params);
//    AFHTTPRequestOperation *op = [http operationWithBuilder:builder];
//    [op setCompletionBlockWithSuccess:success failure:failure];
//    [http enqueueOnlyOperation:op];
//    return op;
//}
@end
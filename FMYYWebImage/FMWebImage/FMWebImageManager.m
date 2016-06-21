//
//  FMWebImageManager.m
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/15.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#import "FMWebImageManager.h"
#import "NSObject+FMWebPrivate.h"


NSString *const FMIMAGEQUALITYSTATUSKEY            =   @"FMIMAGEQUALITYSTATUSKEY";

@interface FMWebImageManager ()
{
    BOOL  _s_qiniuQualityAutoChange;
    BOOL  _isNoAutoChange;
}
@end

@implementation FMWebImageManager
+(void)load
{
    [self shareInstance];
}
+ (instancetype)shareInstance
{
    static FMWebImageManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FMWebImageManager alloc] init];
    });
    return instance;
}
-(id)init
{
    self=[super init];
    if (self) {
        //        _s_qiniuQualityAutoChange=YES;
        self.s_qiniuImageQuality=30;
    }
    return self;
}

-(void)setS_qiniuQualityAutoChange:(BOOL)s_qiniuQualityAutoChange
{
    _s_qiniuQualityAutoChange=s_qiniuQualityAutoChange;
    _isNoAutoChange=!s_qiniuQualityAutoChange;//因为默认要开启，所以做了一个中间参数
    [[NSUserDefaults standardUserDefaults]setBool:_isNoAutoChange forKey:FMIMAGEQUALITYSTATUSKEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(BOOL)s_qiniuQualityAutoChange
{
    _isNoAutoChange=  [[NSUserDefaults standardUserDefaults]boolForKey:FMIMAGEQUALITYSTATUSKEY];
    _s_qiniuQualityAutoChange=!_isNoAutoChange;
    return _s_qiniuQualityAutoChange;
}

#pragma mark placeholder
static NSMutableArray* _defaultPlaceholderImageNames;
static NSMutableArray* _defaultFailureImageNames;
-(void)fm_addPlaceholderImageName:(NSString *)imageName
{
    if(_defaultPlaceholderImageNames == nil) {
        _defaultPlaceholderImageNames = [NSMutableArray array];
    }
    [self fm_array:_defaultPlaceholderImageNames addImageName:imageName];
}
-(void)fm_addFailureImageName:(NSString *)imageName
{
    if(_defaultFailureImageNames == nil) {
        _defaultFailureImageNames = [NSMutableArray array];
    }
    [self fm_array:_defaultFailureImageNames addImageName:imageName];
}
-(void)fm_array:(NSMutableArray*)array addImageName:(NSString*)imageName
{
    UIImage* image = [UIImage imageNamed:imageName];
    if (image) {
        FMWEBImageData* imageData = [[FMWEBImageData alloc] init];
        imageData.size = CGSizeMake(ceil(image.size.width), ceil(image.size.height));
        imageData.pixLenght = imageData.size.width * imageData.size.height;
        imageData.imageName = imageName;
        [array addObject:imageData];
        
        [array sortUsingComparator:^NSComparisonResult(FMWEBImageData* obj1, FMWEBImageData* obj2) {
            if (obj1.pixLenght < obj2.pixLenght) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
    }
}
-(NSString *)fm_getPlaceholderImageNameFromArrayBySize:(CGSize)size
{
    return  [self fm_getImageNameForArray:_defaultPlaceholderImageNames size:size];
}
-(NSString *)fm_getFailureImageNameFromArrayBySize:(CGSize)size
{
    return  [self fm_getImageNameForArray:_defaultFailureImageNames size:size];
}
-(NSString*)fm_getImageNameForArray:(NSArray*)array size:(CGSize)size
{
    NSInteger origWidth = ceil(size.width);
    NSInteger origHeight = ceil(size.height);
    NSString* imageName = nil;
    for (FMWEBImageData* imageData in array) {
        if (imageData.size.width <= origWidth && imageData.size.height <= origHeight) {
            imageName = imageData.imageName;
            break;
        }
    }
    if (imageName == nil) {
        imageName = [array.firstObject imageName];
    }
    return imageName;
}

















@end

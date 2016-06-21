//
//  NSObject+MMWebSwizzle.h
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/15.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (FMWebSwizzle)
+ (BOOL)webimage_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_;
+ (BOOL)webimage_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_;

@end

@interface FMWEBImageData : NSObject
@property NSInteger pixLenght;
@property CGSize size;
@property(copy,nonatomic) NSString* imageName;
@end
@interface FMTapGestureRecognizer : UITapGestureRecognizer

@end


//
//  NSObject+MMWebSwizzle.m
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/15.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#import "NSObject+FMWebPrivate.h"
#import <objc/runtime.h>


@implementation NSObject (FMWebPrivate)
+ (BOOL)webimage_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_
{
    Method origMethod = class_getInstanceMethod(self, origSel_);
    if (!origMethod) {
        return NO;
    }
    Method altMethod = class_getInstanceMethod(self, altSel_);
    if (!altMethod) {
        return NO;
    }
    
    class_addMethod(self,
                    origSel_,
                    class_getMethodImplementation(self, origSel_),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel_,
                    class_getMethodImplementation(self, altSel_),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));
    
    return YES;
}

+ (BOOL)webimage_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_
{
    return [object_getClass((id)self) webimage_swizzleMethod:origSel_ withMethod:altSel_ error:error_];
}

@end



@implementation FMWEBImageData

@end
@implementation FMTapGestureRecognizer

@end
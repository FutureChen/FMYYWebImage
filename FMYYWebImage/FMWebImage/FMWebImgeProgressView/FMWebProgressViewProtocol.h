//
//  FMWebProgressViewProtocol.h
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/17.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FMWebProgressViewProtocol <NSObject>
-(void)fm_webImageProgressViewSetProgress:(CGFloat)progress animated:(BOOL)animated;
@end

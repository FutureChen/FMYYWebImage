//
//  FMWebProgressLayer.h
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/17.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FMWebProgressViewProtocol.h"
#import <UIKit/UIKit.h>
@interface FMWebProgressLayer : CAShapeLayer<FMWebProgressViewProtocol>
@property (nonatomic,strong)CAShapeLayer* progressLayer;
@end

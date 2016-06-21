//
//  TableViewCell.h
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/15.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYImage.h"
#import "YYWebImage.h"
#import "UIImageView+YYWebImage.h"
#import "UIView+YYAdd.h"
#import "CALayer+YYAdd.h"
#import "UIGestureRecognizer+YYAdd.h"
#define kCellHeight ceil((kScreenWidth) * 3.0 / 4.0)
#define kScreenWidth ((UIWindow *)[UIApplication sharedApplication].windows.firstObject).width
@interface TableViewCell : UITableViewCell
@property (nonatomic, strong) YYAnimatedImageView *webImageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UILabel *label;

- (void)setImageURL:(NSURL *)url ;
@end

//
//  ViewController.m
//  FMYYWebImage
//
//  Created by 陈炜来 on 16/6/15.
//  Copyright © 2016年 陈炜来. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController
{
    NSArray *_imageLinks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStylePlain target:self action:@selector(reload)];
    self.navigationItem.rightBarButtonItem = button;
    self.view.backgroundColor = [UIColor colorWithWhite:0.217 alpha:1.000];
    
    NSArray *links = @[
                       /*
                        You can add your image url here.
                        */
//                       @"http://7xod7k.com2.z0.glb.qiniucdn.com/00f63b5e398b41d6b690768ab8dc49f3.jpg",
//                       @"http://7xod7k.com2.z0.glb.qiniucdn.com/98285944de97428298e3b7e326abe71c.jpg",
//                       @"http://7xod7k.com2.z0.glb.qiniucdn.com/bf7924b2adef4ca1b875939cc4569113.jpg",
                       // progressive jpeg
                       @"https://s-media-cache-ak0.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg",
                       
                       // animated gif: http://cinemagraphs.com/
                       @"http://i.imgur.com/uoBwCLj.gif",
                       @"http://i.imgur.com/8KHKhxI.gif",
                       @"http://i.imgur.com/WXJaqof.gif",
                       
                       // animated gif: https://dribbble.com/markpear
                       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1780193/dots18.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1809343/dots17.1.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1845612/dots22.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1820014/big-hero-6.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1819006/dots11.0.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1799885/dots21.gif",
                       
                       // animaged gif: https://dribbble.com/jonadinges
                       @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/2025999/batman-beyond-the-rain.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1855350/r_nin.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1963497/way-back-home.gif",
                       @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1913272/depressed-slurp-cycle.gif",
                       
                       // jpg: https://dribbble.com/snootyfox
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2047158/beerhenge.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1839353/pilsner.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1833469/porter.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1521183/farmers.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1391053/tents.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1399501/imperial_beer.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1488711/fishin.jpg",
                       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1466318/getaway.jpg",
                       
                       // animated webp and apng: http://littlesvr.ca/apng/gif_apng_webp.html
                       @"http://littlesvr.ca/apng/images/BladeRunner.png",
                       @"http://littlesvr.ca/apng/images/Contact.webp",
                       ];
    
    _imageLinks = links;
    [self.tableView reloadData];
    [self scrollViewDidScroll:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.tintColor = nil;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)reload {
    [[YYImageCache sharedCache].memoryCache removeAllObjects];
    [[YYImageCache sharedCache].diskCache removeAllObjectsWithBlock:^{}];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _imageLinks.count * 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [cell setImageURL:[NSURL URLWithString:_imageLinks[indexPath.row % _imageLinks.count]]];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat viewHeight = scrollView.height + scrollView.contentInset.top;
    for (TableViewCell *cell in [self.tableView visibleCells]) {
        CGFloat y = cell.centerY - scrollView.contentOffset.y;
        CGFloat p = y - viewHeight / 2;
        CGFloat scale = cos(p / viewHeight * 0.8) * 0.95;
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            cell.webImageView.transform = CGAffineTransformMakeScale(scale, scale);
        } completion:NULL];
    }
}

@end

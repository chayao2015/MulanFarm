//
//  BaseNC.m
//  ArtEast
//
//  Created by yibao on 16/9/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "BaseNC.h"

// 弄一个子类继承nvc,在这里实现返回动画的代理方法
@interface BaseNC () <UINavigationControllerDelegate>

@end

@implementation BaseNC

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 设置UINavigationBar的样式
//    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
//    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
//    [[UINavigationBar appearance] setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:
//      [UIColor blackColor], NSForegroundColorAttributeName,
//      [UIFont systemFontOfSize:17], NSFontAttributeName, nil]]; //kColorFromRGBHex(0x2a2a2a)
}

@end

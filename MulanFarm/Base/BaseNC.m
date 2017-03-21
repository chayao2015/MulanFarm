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
    [[UINavigationBar appearance] setBarTintColor:AEColor(112, 195, 8, 1)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,
      [UIFont systemFontOfSize:17], NSFontAttributeName, nil]];
}

@end

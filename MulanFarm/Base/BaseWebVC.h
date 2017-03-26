//
//  BaseWebController.h
//  RentalCar
//
//  Created by zyl on 17/3/23.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseVC.h"

@interface BaseWebVC : BaseVC

@property (strong, nonatomic) NSString *homeUrl;
@property (strong, nonatomic) NSString *webTitle;
@property (assign, nonatomic) BOOL isPresent;

/** 传入控制器、url、标题 H5获取参数*/
+ (void)showWithContro:(UIViewController *)contro withUrlStr:(NSString *)urlStr withTitle:(NSString *)title isPresent:(BOOL)isPresent;

@end

//
//  MineVC.m
//  YiHeYun
//
//  Created by mac on 2017/3/8.
//  Copyright © 2017年 yhy. All rights reserved.
//

#import "MineVC.h"

@interface MineVC ()

@end

@implementation MineVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBar.hidden = NO;
    
    if ([Utils isUserLogin]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"啄木鸟", @"nick_name",
                             @"0", @"gender",
                             @"上海上海市", @"area",
                             @"浦东新区金海路2100号", @"address",
                             @"无个性,不签名", @"signature",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_UpdateUserInfo parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            
            if (status == Request_Success) {
                [Utils showToast:@"修改信息成功"];
                
                //[[UserInfo share] setUserInfo:responseData];
            } else {
                [Utils showToast:@"修改信息失败"];
            }
        }];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的";
    
    [self setNavBar];
}

- (void)setNavBar {
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"bell"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navItem.leftBarButtonItem = leftItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

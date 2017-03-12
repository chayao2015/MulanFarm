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
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"啄木鸟", @"nick_name",
                         @"0", @"gender",
                         @"上海上海市", @"area",
                         @"浦东新区金海路2100号", @"address",
                         @"无个性,不签名", @"signature",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_UpdateUserInfo parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"修改信息成功"];
            
            [[UserInfo share] setUserInfo:responseData];
        } else {
            [Utils showToast:@"修改信息失败"];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

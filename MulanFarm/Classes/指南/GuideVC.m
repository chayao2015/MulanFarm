//
//  GuideVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/9.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "GuideVC.h"

@interface GuideVC ()

@end

@implementation GuideVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"cliveyuan@foxmail.com", @"email",
                         [AESCrypt encrypt:@"123456" password:AESSecret], @"user_pwd",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_Register parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"注册成功"];
            
            [[UserInfo share] setUserInfo:responseData];
        } else {
            [Utils showToast:@"注册失败"];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"指南";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

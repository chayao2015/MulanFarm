//
//  RecordVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/9.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "RecordVC.h"

@interface RecordVC ()

@end

@implementation RecordVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"cliveyuan@foxmail.com", @"email",
                         [AESCrypt encrypt:@"123456" password:AESSecret], @"user_pwd",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_Login parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"登录成功"];
            
            [[UserInfo share] setUserInfo:responseData];
        } else {
            [Utils showToast:@"登录失败"];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"档案";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

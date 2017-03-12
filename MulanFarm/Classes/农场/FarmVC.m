//
//  FarmVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/9.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "FarmVC.h"

@interface FarmVC ()

@end

@implementation FarmVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NetworkManager sharedManager] postJSON:URL_SignIn parameters:nil imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"签到成功"];
        } else {
            [Utils showToast:@"签到失败"];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"农场";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

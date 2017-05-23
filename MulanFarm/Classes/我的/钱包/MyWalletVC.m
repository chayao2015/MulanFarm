//
//  MyWalletVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/22.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "MyWalletVC.h"
#import "RechargeVC.h"
#import "PayVC.h"

@interface MyWalletVC ()

@end

@implementation MyWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的钱包";
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].avatar] placeholderImage:[UIImage imageNamed:@"header"]];
    self.nickLab.text = [Utils isBlankString:[UserInfo share].nick_name]?@"暂无昵称":[UserInfo share].nick_name;
    
    self.headImgView.layer.cornerRadius = self.headImgView.width/2;
    [self.headImgView.layer setMasksToBounds:YES];
    
    self.fukuanBtn.layer.borderColor = AppThemeColor.CGColor;
    self.fukuanBtn.layer.borderWidth = 0.6;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//充值
- (IBAction)chongzhiAction:(id)sender {
    
    RechargeVC *vc = [[RechargeVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//付款
- (IBAction)fukuanAction:(id)sender {
    
    PayVC *vc = [[PayVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

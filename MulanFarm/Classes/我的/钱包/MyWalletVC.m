//
//  MyWalletVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/22.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "MyWalletVC.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chongzhiAction:(id)sender {
}

- (IBAction)fukuanAction:(id)sender {
}
@end

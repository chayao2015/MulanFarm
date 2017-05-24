//
//  PayVC.m
//  MulanFarm
//
//  Created by zhanbing han on 2017/5/23.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "PayVC.h"
#import "WXApi.h"

@interface PayVC ()
{
    UILabel *moneyLab;
    UITextField *moneyTF;
    UIButton *rechargeBtn;
}
@end

@implementation PayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"付款";
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 84, WIDTH, 50)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 80, 20)];
    moneyLab.text = @"付款金额";
    moneyLab.font = [UIFont systemFontOfSize:15];
    moneyLab.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:moneyLab];
    
    moneyTF = [[UITextField alloc] initWithFrame:CGRectMake(moneyLab.maxX, 15, WIDTH-120, 20)];
    moneyTF.placeholder = @"请输入付款金额(元)";
    moneyTF.font = [UIFont systemFontOfSize:15];
    [topView addSubview:moneyTF];
    
    rechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, topView.maxY+30, WIDTH-40, 44)];
    rechargeBtn.layer.cornerRadius = 8;
    [rechargeBtn.layer setMasksToBounds:YES];
    rechargeBtn.backgroundColor = AppThemeColor;
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rechargeBtn setTitle:@"付款" forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(transferPay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rechargeBtn];
}

#pragma mark - 转账

- (void)transferPay
{
    if ([Utils isBlankString:moneyTF.text]) {
        [Utils showToast:@"请输入付款金额"];
        return;
    }
    
    [self.view endEditing:YES];
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         moneyTF.text, @"amount",
                         @"admin", @"payee",
                        nil];
    [[NetworkManager sharedManager] postJSON:URL_Transfer parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        if (status == Request_Success) {
            [Utils showToast:@"付款成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

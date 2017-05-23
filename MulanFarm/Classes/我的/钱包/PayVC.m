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
    moneyTF.keyboardType = UIKeyboardTypeNumberPad;
    moneyTF.font = [UIFont systemFontOfSize:15];
    [topView addSubview:moneyTF];
    
    rechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, topView.maxY+30, WIDTH-40, 44)];
    rechargeBtn.layer.cornerRadius = 8;
    [rechargeBtn.layer setMasksToBounds:YES];
    rechargeBtn.backgroundColor = AppThemeColor;
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rechargeBtn setTitle:@"付款" forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(wxpay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rechargeBtn];
}

#pragma mark - 微信支付

- (void)wxpay
{
    if ([Utils isBlankString:moneyTF.text]) {
        [Utils showToast:@"请输入付款金额"];
        return;
    }
    
    if (![WXApi isWXAppInstalled] && ![WXApi isWXAppSupportApi]) {
        [Utils showToast:@"您未安装微信客户端，请安装微信以完成支付"];
    } else {
        
        [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [UserInfo share].ID, @"memberID",
                             @"", @"payment_order_id",
                             @"wxpay", @"payment_pay_app_id",
                             @"wx55bc4907e6c26338", @"openid",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_UpdateUserInfo parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            
            [JHHJView hideLoading]; //结束加载
            
            if (status == Request_Success) {
                if ([responseData isKindOfClass:[NSDictionary class]]) {
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.openID              = responseData[@"appid"];
                    req.partnerId           = responseData[@"partnerid"];
                    req.prepayId            = responseData[@"prepay_id"];
                    req.nonceStr            = responseData[@"noncestr"];
                    NSMutableString *stamp  = responseData[@"timestamp"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = responseData[@"package1"];
                    req.sign                = responseData[@"sign"];
                    [WXApi sendReq:req];
                }
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

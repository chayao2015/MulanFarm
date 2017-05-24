//
//  RechargeVC.m
//  MulanFarm
//
//  Created by zhanbing han on 2017/5/23.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "RechargeVC.h"
#import "WXApi.h"

@interface RechargeVC ()
{
    UILabel *moneyLab;
    UITextField *moneyTF;
    UIButton *rechargeBtn;
    
    NSString *prepay_id;
}
@end

@implementation RechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"充值";
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 84, WIDTH, 50)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 80, 20)];
    moneyLab.text = @"充值金额";
    moneyLab.font = [UIFont systemFontOfSize:15];
    moneyLab.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:moneyLab];
    
    moneyTF = [[UITextField alloc] initWithFrame:CGRectMake(moneyLab.maxX, 15, WIDTH-120, 20)];
    moneyTF.placeholder = @"请输入充值金额(元)";
    moneyTF.font = [UIFont systemFontOfSize:15];
    [topView addSubview:moneyTF];
    
    rechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, topView.maxY+30, WIDTH-40, 44)];
    rechargeBtn.layer.cornerRadius = 8;
    [rechargeBtn.layer setMasksToBounds:YES];
    rechargeBtn.backgroundColor = AppThemeColor;
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(wxpay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rechargeBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"PaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFail) name:@"PayFail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCancel) name:@"PayCancel" object:nil];
}

//支付成功
- (void)paySuccess {
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         prepay_id, @"prepay_id",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_PayQuery parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"支付成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kRechargeSuccNotification object:nil];
        } else {
            [Utils showToast:@"支付失败，请重新支付"];
        }
    }];
}

//支付失败
- (void)payFail {
    [Utils showToast:@"支付失败，请重新支付"];
}

//支付取消
-(void)payCancel {
    [Utils showToast:@"支付取消"];
}

#pragma mark - 微信支付

- (void)wxpay
{
    if ([Utils isBlankString:moneyTF.text]) {
        [Utils showToast:@"请输入充值金额"];
        return;
    }
    
    [self.view endEditing:YES];
    
    if (![WXApi isWXAppInstalled] && ![WXApi isWXAppSupportApi]) {
        [Utils showToast:@"您未安装微信客户端，请安装微信以完成支付"];
    } else {
        
        [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"wx55bc4907e6c26338", @"appid",
                             moneyTF.text, @"total_fee",
                             [Utils getIPAddress], @"spbill_create_ip",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_Recharge parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
            
            [JHHJView hideLoading]; //结束加载
            
            if (status == Request_Success) {
                if ([responseData isKindOfClass:[NSDictionary class]]) {
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.openID              = responseData[@"appid"];
                    req.partnerId           = responseData[@"partnerid"];
                    req.prepayId            = responseData[@"prepayid"];
                    prepay_id               = responseData[@"prepayid"];
                    req.nonceStr            = responseData[@"noncestr"];
                    NSMutableString *stamp  = responseData[@"timestamp"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = responseData[@"package"];
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

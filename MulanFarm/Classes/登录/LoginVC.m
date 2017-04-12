//
//  LoginVC.m
//  YiHeYun
//
//  Created by mac on 2017/3/8.
//  Copyright © 2017年 yhy. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.checkBtn.layer.borderWidth = 1;
    self.checkBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.checkBtn.layer.cornerRadius = 3;
    [self.checkBtn.layer setMasksToBounds:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    //cliveyuan@foxmail.com 1234567
    
    if ([Utils isBlankString:_accountTF.text]) {
        [Utils showToast:@"请输入用户名"];
        return;
    }
    
    if (![Utils validateEmail:_accountTF.text]) {
        [Utils showToast:@"请输入正确的邮箱"];
        return;
    }
    
    if ([Utils isBlankString:_pswTF.text]) {
        [Utils showToast:@"请输入密码"];
        return;
    }
    
    if (_pswTF.text.length<6) {
        [Utils showToast:@"密码不能小于6位"];
        return;
    }
    
    if (_checkBtn.selected==NO) {
        [Utils showToast:@"请选择用户协议"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _accountTF.text, @"email",
                         [AESCrypt encrypt:_pswTF.text password:AESSecret], @"user_pwd",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_Login parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"登录成功"];
            
            [[UserInfo share] setUserInfo:responseData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccNotification object:nil];
            
            if (self.buttonBlock) {
                self.buttonBlock();
            }
        } else {
            [Utils showToast:@"登录失败"];
        }
    }];
}

- (IBAction)checkProtocalAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.isSelected) {
        self.checkBtn.layer.borderColor = AppThemeColor.CGColor;
    } else {
        self.checkBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

@end

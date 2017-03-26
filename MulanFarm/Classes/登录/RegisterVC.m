//
//  RegisterVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/21.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"注册";
    
    self.checkBtn.layer.borderWidth = 0.6;
    self.checkBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.checkBtn.layer.cornerRadius = 3;
    [self.checkBtn.layer setMasksToBounds:YES];
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

- (IBAction)getCodeAction:(id)sender {
    
}

- (IBAction)clickProtocalAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.isSelected) {
        self.checkBtn.layer.borderColor = AppThemeColor.CGColor;
    } else {
        self.checkBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

- (IBAction)registerAction:(id)sender {
    
    if ([Utils isBlankString:_emailTF.text]) {
        [Utils showToast:@"请输入您的邮箱"];
        return;
    }
    
    if ([Utils isBlankString:_codeTF.text]) {
        [Utils showToast:@"请输入验证码"];
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
                         @"ios", @"terminal_type",
                         _emailTF.text, @"email",
                         [AESCrypt encrypt:_pswTF.text password:AESSecret], @"user_pwd",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_Register parameters:dic imageDataArr:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"注册成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [Utils showToast:@"注册失败"];
        }
    }];
}

@end

//
//  ChangePswVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/25.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "ChangePswVC.h"

@interface ChangePswVC ()

@end

@implementation ChangePswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"修改密码";
    
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

//完成
- (IBAction)doneAction:(id)sender {
    
    if ([Utils isBlankString:_oldPsw.text]) {
        [Utils showToast:@"请输入旧密码"];
        return;
    }
    
    if ([Utils isBlankString:_xinPsw.text]) {
        [Utils showToast:@"请输入新密码"];
        return;
    }
    
    if ([Utils isBlankString:_confirmNewPsw.text]) {
        [Utils showToast:@"请再次输入新密码"];
        return;
    }
    
    if (_xinPsw.text.length<6) {
        [Utils showToast:@"密码不能小于6位"];
        return;
    }
    
    if (![_xinPsw.text isEqual:_confirmNewPsw.text]) {
        [Utils showToast:@"2次密码输入不一致"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [AESCrypt encrypt:_oldPsw.text password:AESSecret], @"old_pwd",
                         [AESCrypt encrypt:_xinPsw.text password:AESSecret], @"new_pwd",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_UpdatePwd parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"密码修改成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [Utils showToast:@"密码修改失败"];
        }
    }];
}

@end

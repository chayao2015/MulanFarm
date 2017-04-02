//
//  RegisterVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/21.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "RegisterVC.h"

#define kCountDownTime 59

@interface RegisterVC ()

//短信验证码相关
@property (nonatomic,assign) NSUInteger countDownTime;
@property (nonatomic,strong) NSTimer *timer;

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

//获取验证码
- (IBAction)getCodeAction:(id)sender {
    
    [self startCountDown];
}

//勾选协议
- (IBAction)checkProtocalAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
}

//点击用户协议
- (IBAction)clickProtocalAction:(id)sender {
    
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_Agreement parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            [BaseWebVC showWithContro:self withUrlStr:responseData withTitle:@"用户协议" isPresent:NO];
        }
    }];
}

//注册
- (IBAction)registerAction:(id)sender {
    
    if ([Utils isBlankString:_emailTF.text]) {
        [Utils showToast:@"请输入您的邮箱"];
        return;
    }
    
    if (![Utils validateEmail:_emailTF.text]) {
        [Utils showToast:@"请输入正确的邮箱"];
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

#pragma mark - 获取验证码

- (void)startCountDown
{
    [self.view endEditing:YES];
    
    if ([Utils validateEmail:_emailTF.text]) {
        _countDownTime = kCountDownTime;
        [_codeBtn setTitle:[NSString stringWithFormat:@"%lu秒",(unsigned long)_countDownTime] forState:UIControlStateNormal];
        _codeBtn.userInteractionEnabled = NO;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        [self getSmsCode];
    } else {
        [Utils showToast:@"请输入正确的邮箱"];
    }
}

- (void)changeTime
{
    _countDownTime--;
    [_codeBtn setTitle:[NSString stringWithFormat:@"%lu秒",(unsigned long)_countDownTime] forState:UIControlStateNormal];
    if (_countDownTime <= 0)
    {
        [self timerOver];
    }
}

//定时器结束
- (void)timerOver
{
    [_codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    _codeBtn.userInteractionEnabled = YES;
    [_timer invalidate];
    
    //防止_timer被释放掉后还继续访问
    _timer = nil;
}

//获取邮箱验证码
- (void)getSmsCode
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
               _emailTF.text, @"email",
               nil];
    
    [[NetworkManager sharedManager] postJSON:URL_SendEmailCaptcha parameters:dic imageDataArr:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"验证码已发送到您的邮箱"];
        } else {
            [self timerOver];
        }
    }];
}

@end

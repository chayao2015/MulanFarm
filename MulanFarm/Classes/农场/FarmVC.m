//
//  FarmVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/9.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "FarmVC.h"
#import "ViewController.h"

@interface FarmVC ()

@end

@implementation FarmVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"农场";
    
    [self setNavBar];
    
    self.clearNoteBtn.layer.borderColor = AppThemeColor.CGColor;
    self.clearNoteBtn.layer.borderWidth = 1;
    self.clearNoteBtn.layer.cornerRadius = 5;
    [self.clearNoteBtn.layer setMasksToBounds:YES];
    
}

- (void)setNavBar {
    
    self.bellCountLab.layer.cornerRadius = self.bellCountLab.width/2;
    [self.bellCountLab.layer setMasksToBounds:YES];
    
    self.signBtn.layer.borderWidth = 1;
    self.signBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.signBtn.layer.cornerRadius = 5;
    [self.signBtn.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//消息中心
- (IBAction)addCameraBtn:(id)sender {
}

- (IBAction)bellAction:(id)sender {
    ViewController *testVC = [[ViewController alloc] init];
    testVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:testVC animated:YES];
}

//签到
- (IBAction)signAction:(id)sender {
    [[NetworkManager sharedManager] postJSON:URL_SignIn parameters:nil imageDataArr:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"签到成功"];
        } else {
            [Utils showToast:@"签到失败"];
        }
    }];
}

- (IBAction)showRecordAction:(id)sender {
    
    
}

- (IBAction)clearNoteAction:(id)sender {
    
    _titleTF.text = nil;
    _contentTF.text = nil;
}

- (IBAction)saveNoteAction:(id)sender {
    
    if ([Utils isBlankString:_titleTF.text]) {
        [Utils showToast:@"请输入笔记标题"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _titleTF.text, @"title",
                         _contentTF.text,@"content",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_SaveNote parameters:dic imageDataArr:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"保存成功"];
            
            _titleTF.text = nil;
            _contentTF.text = nil;
        } else {
            [Utils showToast:@"保存失败"];
        }
    }];
}

@end

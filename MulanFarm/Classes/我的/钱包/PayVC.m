//
//  PayVC.m
//  MulanFarm
//
//  Created by zhanbing han on 2017/5/23.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "PayVC.h"

@interface PayVC ()

@end

@implementation PayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"付款";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2-100, HEIGHT/2-100, 200, 200)];
    imgView.image = [UIImage imageNamed:@"收款二维码"];
    [self.view addSubview:imgView];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.maxY+20, WIDTH, 20)];
    tipLab.text = @"用微信扫描二维码付款";
    tipLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

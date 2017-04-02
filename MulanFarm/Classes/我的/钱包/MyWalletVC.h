//
//  MyWalletVC.h
//  MulanFarm
//
//  Created by zyl on 17/3/22.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "BaseVC.h"

@interface MyWalletVC : BaseVC

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nickLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@property (weak, nonatomic) IBOutlet UIButton *chongzhiBtn;
@property (weak, nonatomic) IBOutlet UIButton *fukuanBtn;


- (IBAction)chongzhiAction:(id)sender;

- (IBAction)fukuanAction:(id)sender;


@end

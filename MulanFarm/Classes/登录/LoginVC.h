//
//  LoginVC.h
//  YiHeYun
//
//  Created by mac on 2017/3/8.
//  Copyright © 2017年 yhy. All rights reserved.
//

#import "BaseVC.h"
#import "ZBTextField.h"

@interface LoginVC : BaseVC

@property (nonatomic,copy) dispatch_block_t buttonBlock;

@property (weak, nonatomic) IBOutlet ZBTextField *accountTF;
@property (weak, nonatomic) IBOutlet ZBTextField *pswTF;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

- (IBAction)loginAction:(id)sender;
- (IBAction)checkProtocalAction:(id)sender;

@end

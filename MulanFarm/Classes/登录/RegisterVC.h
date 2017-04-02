//
//  RegisterVC.h
//  MulanFarm
//
//  Created by zyl on 17/3/21.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "BaseVC.h"

@interface RegisterVC : BaseVC

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

- (IBAction)getCodeAction:(id)sender;

- (IBAction)checkProtocalAction:(id)sender;

- (IBAction)clickProtocalAction:(id)sender;

- (IBAction)registerAction:(id)sender;

@end

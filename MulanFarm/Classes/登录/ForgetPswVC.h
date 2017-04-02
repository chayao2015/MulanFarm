//
//  ForgetPswVC.h
//  MulanFarm
//
//  Created by zyl on 17/3/21.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "BaseVC.h"

@interface ForgetPswVC : BaseVC

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;


- (IBAction)getEmailCode:(id)sender;

- (IBAction)findPswAction:(id)sender;

@end

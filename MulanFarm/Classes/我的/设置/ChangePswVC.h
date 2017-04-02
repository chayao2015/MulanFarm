//
//  ChangePswVC.h
//  MulanFarm
//
//  Created by zyl on 17/3/25.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "BaseVC.h"

@interface ChangePswVC : BaseVC

@property (weak, nonatomic) IBOutlet UITextField *oldPsw;
@property (weak, nonatomic) IBOutlet UITextField *xinPsw;
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPsw;

- (IBAction)doneAction:(id)sender;


@end

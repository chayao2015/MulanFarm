//
//  AddCameraVC.h
//  MulanFarm
//
//  Created by zhanbing han on 17/4/2.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "BaseVC.h"

@interface AddCameraVC : BaseVC

@property (weak, nonatomic) IBOutlet UIButton *addPicBtn;
@property (weak, nonatomic) IBOutlet UIImageView *addPicImgView;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;

- (IBAction)picClickAction:(id)sender;

- (IBAction)bindingCameraAction:(id)sender;


@end

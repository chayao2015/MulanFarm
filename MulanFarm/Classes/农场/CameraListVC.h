//
//  CameraListVC.h
//  MulanFarm
//
//  Created by zhanbing han on 17/4/3.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "BaseVC.h"
#import "BackProtocol.h"

@interface CameraListVC : BaseVC

@property (weak, nonatomic) IBOutlet UITableView *cameraTableView;
@property (weak, nonatomic) IBOutlet UIButton *addCameraBtn;

@property (nonatomic, weak)  id<BackProtocol> backDelegate;

@end

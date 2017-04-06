//
//  CameraListCell.h
//  MulanFarm
//
//  Created by zhanbing han on 17/4/3.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraInfo.h"

@interface CameraListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (nonatomic,retain) CameraInfo *info;

@end

//
//  BellCell.h
//  MulanFarm
//
//  Created by zhanbing han on 17/4/2.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BellInfo.h"

@interface BellCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic,retain) BellInfo *info;

@end

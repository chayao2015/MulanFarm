//
//  NoteCell.h
//  MulanFarm
//
//  Created by zyl on 17/3/25.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteInfo.h"

@interface NoteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic,retain) NoteInfo *info;

@end

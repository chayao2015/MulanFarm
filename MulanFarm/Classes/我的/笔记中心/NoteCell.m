//
//  NoteCell.m
//  MulanFarm
//
//  Created by zyl on 17/3/25.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "NoteCell.h"

@implementation NoteCell

- (void)setInfo:(NoteInfo *)info {
    
    _titleLab.text = info.title;
    _contentLab.text = info.content;
    _timeLab.text = info.create_date;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

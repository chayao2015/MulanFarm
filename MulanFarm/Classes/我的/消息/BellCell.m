//
//  BellCell.m
//  MulanFarm
//
//  Created by zhanbing han on 17/4/2.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "BellCell.h"

@implementation BellCell

- (void)setInfo:(BellInfo *)info {
    
    self.imgView.image = [UIImage imageNamed:@"logoIcon"];
    self.imgView.layer.cornerRadius = self.imgView.width/2;
    [self.imgView.layer setMasksToBounds:YES];
    self.titleLab.text = info.title;
    self.contentLab.text = info.content;
    self.timeLab.text = info.create_date;
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

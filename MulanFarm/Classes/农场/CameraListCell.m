//
//  CameraListCell.m
//  MulanFarm
//
//  Created by zhanbing han on 17/4/3.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "CameraListCell.h"

@implementation CameraListCell

- (void)setInfo:(CameraInfo *)info {
    
    if (_info!=info) {
        _info = info;
    }
    
    self.imgView.layer.cornerRadius = self.imgView.width/2;
    [self.imgView.layer setMasksToBounds:YES];

    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_info.thumbnail] placeholderImage:[UIImage imageNamed:@"logoIcon"]];
    self.numberLab.text = _info.camera_no;
    self.nameLab.text = _info.name;
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

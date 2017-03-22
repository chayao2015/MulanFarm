//
//  MineVC.h
//  YiHeYun
//
//  Created by mac on 2017/3/8.
//  Copyright © 2017年 yhy. All rights reserved.
//

#import "BaseVC.h"

@interface MineVC : BaseVC

@property (weak, nonatomic) IBOutlet UIButton *bellBtn;
@property (weak, nonatomic) IBOutlet UILabel *bellCountLab;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)signAction:(id)sender;


@end

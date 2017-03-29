//
//  RecordVC.h
//  MulanFarm
//
//  Created by zyl on 17/3/9.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "BaseVC.h"

@interface RecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *ageLB;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;

@end

@interface RecordVC : BaseVC<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *recordTabView;

@end

//
//  RecordDetailVC.h
//  MulanFarm
//
//  Created by zhanbing han on 17/3/28.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "BaseVC.h"
#import "ArchiveInfo.h"

@interface DetailesTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *valueLB;

@end

@interface RecordDetailVC : BaseVC

@property (nonatomic,retain) ArchiveInfo *info;

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn1;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn2;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn3;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn4;
@property (weak, nonatomic) IBOutlet UIButton *imgtn5;
@property (weak, nonatomic) IBOutlet UITableView *detaileTabView;



@end

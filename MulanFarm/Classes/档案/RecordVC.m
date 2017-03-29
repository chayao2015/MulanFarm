//
//  RecordVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/9.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "RecordVC.h"
#import "ArchiveInfo.h"
#import "RecordDetailVC.h"

@implementation RecordCell

@end

@interface RecordVC ()
{
    NSMutableArray *_dataArr; //列表数组
}
@end

@implementation RecordVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"档案";
    
    _dataArr = [NSMutableArray array];
    
    [self getData];
}

- (void)getData {
    
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_ArchiveList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            [_dataArr removeAllObjects];
            
            _dataArr = [ArchiveInfo mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
            
            [self.recordTabView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"RecordCell";
    
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[RecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ArchiveInfo *info = _dataArr[indexPath.row];
    cell.nameLB.text = info.name;
    cell.ageLB.text = info.age;
    cell.dateLB.text = info.adop_time;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //取消选择状态
    
    ArchiveInfo *info = _dataArr[indexPath.row];
    RecordDetailVC *vc = [[RecordDetailVC alloc] init];
    vc.info = info;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

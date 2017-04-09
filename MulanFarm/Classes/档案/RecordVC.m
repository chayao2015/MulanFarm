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
    
    self.recordTabView.tableFooterView = [UIView new];
    
    [self getData];
}

- (void)getData {
    
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_ArchiveList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            [_dataArr removeAllObjects];
            
            _dataArr = [ArchiveInfo mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
            
//            ArchiveInfo *info = [[ArchiveInfo alloc] init];
//            info.ID = @"erhgiorhot";
//            info.variety = @"uhruirgeghir";
//            info.adop_time = @"kwinfgorig";
//            info.name = @"erhgiorhot";
//            info.age = @"uhruirgeghir";
//            info.weight = @"kwinfgorig";
//            info.height = @"kwinfgorig";
//            info.address = @"erhgiorhot";
//            info.hobby = @"uhruirgeghir";
//            info.hate = @"kwinfgorig";
//            [_dataArr addObject:info];
//            [_dataArr addObject:info];
//            
//            NSLog(@"%@",_dataArr);
            
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

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ArchiveInfo *info = _dataArr[indexPath.row];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             info.ID, @"id",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_ArchiveDelete parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            
            if (status == Request_Success) {
                
                [Utils showToast:@"删除成功"];
                [self getData];
            }
        }];
    }
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //取消选择状态
    
    ArchiveInfo *info = _dataArr[indexPath.row];
    RecordDetailVC *vc = (RecordDetailVC *)[Utils GetStordyVC:@"Main" WithStordyID:@"RecordDetailVC"];
    vc.info = info;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

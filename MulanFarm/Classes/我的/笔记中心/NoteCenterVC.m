//
//  NoteCenterVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/22.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "NoteCenterVC.h"
#import "NoteCell.h"
#import "NoteDetailVC.h"

@interface NoteCenterVC ()
{
    NSMutableArray *_dataArr;
}
@end

@implementation NoteCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"笔记中心";
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-35, 7, 30, 30)];
    [addBtn setImage:[UIImage imageNamed:@"AddNote"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navItem.rightBarButtonItem = addBarButtonItem;
    
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_NoteList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            _dataArr = [NoteInfo mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
            
            [_noteTableView reloadData];
        }
    }];
}

- (void)addAction {
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"NoteCell";
    
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    NoteInfo *info = _dataArr[indexPath.row];
    
    cell.info = info;
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //取消选择状态
    
    NoteInfo *info = _dataArr[indexPath.row];
    
    NoteDetailVC *vc = [[NoteDetailVC alloc] init];
    vc.info = info;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

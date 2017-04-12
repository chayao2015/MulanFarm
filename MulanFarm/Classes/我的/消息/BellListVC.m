//
//  BellListVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/22.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "BellListVC.h"
#import "BellCell.h"
#import "BellDetailVC.h"

@interface BellListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArr;
}
@end

@implementation BellListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSUserDefaults standardUserDefaults] setObject:@"已读" forKey:@"MessageRead"];
    
    self.title = @"消息列表";
    
    self.bellTableView.delegate = self;
    self.bellTableView.dataSource = self;
    
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_MsgList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            _dataArr = [BellInfo mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
            
            [_bellTableView reloadData];
        }
    }];
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
    
    static NSString *ID = @"BellCell";
    
    BellCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BellCell" owner:nil options:nil] firstObject];
    }
    
    BellInfo *info = _dataArr[indexPath.row];
    
    cell.info = info;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //取消选择状态
    
    BellInfo *info = _dataArr[indexPath.row];
    
    BellDetailVC *vc = [[BellDetailVC alloc] init];
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

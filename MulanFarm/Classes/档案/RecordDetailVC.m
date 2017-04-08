//
//  RecordDetailVC.m
//  MulanFarm
//
//  Created by zhanbing han on 17/3/28.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "RecordDetailVC.h"
#import <UIButton+WebCache.h>

@implementation DetailesTabCell



@end

@interface RecordDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *titleArr;
    NSArray *valueArr;
    NSArray *imgBtnArr;
}
@end

@implementation RecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"档案详情";
    titleArr = @[@"品种",@"领养时间",@"年龄",@"体重(kg)",@"身高(cm)",@"爱好",@"讨厌"];
    valueArr = @[@"",@"",@"",@"",@"",@"",@""];
    self.detaileTabView.tableHeaderView = _headView;
    imgBtnArr = @[_imgBtn1,_imgBtn2,_imgBtn3,_imgBtn4,_imgtn5];
    [self getData];
    
    self.detaileTabView.tableFooterView = [UIView new];
    
}
-(void)getData{
    NSDictionary *dic = @{@"id":_info.ID};
     [[NetworkManager sharedManager] postJSON:URL_ArchiveDetaile parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
         
         if (status == Request_Success) {
             NSLog(@"%@",responseData);
             NSDictionary *dataDic = responseData;
             valueArr = @[dataDic[@"variety"],dataDic[@"create_date"],dataDic[@"variety"],dataDic[@"weight"],dataDic[@"height"],dataDic[@"hobby"],dataDic[@"hate"]];
             NSArray *listArr =  dataDic[@"albums"];
             NSInteger count = MIN(listArr.count, imgBtnArr.count);
             for (NSInteger  i = 0 ; i< count;i++) {
                 UIButton *btn = imgBtnArr[i];
                 NSDictionary *dic = listArr[i];
                 [btn sd_setImageWithURL:[NSURL URLWithString:dic[@"pic_path"]] forState:0];
                 btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
                 btn.backgroundColor = [UIColor clearColor];
             }
             [self.detaileTabView reloadData];
         }
         
     }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailesTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailesTabCell"];
    cell.nameLB.text = titleArr[indexPath.row];
    cell.valueLB.text = [NSString stringWithFormat:@"%@",valueArr[indexPath.row]];
    return cell;
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

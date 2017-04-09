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

@interface RecordDetailVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray *titleArr;
    NSMutableArray *valueArr;
    NSArray *imgBtnArr;
    NSMutableDictionary *postDic;
    NSArray *postKeyArr;
    BOOL isCanEdit;
    NSInteger currentIndex;
}
@end

@implementation RecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"档案详情";
    titleArr = @[@"姓名",@"品种",@"领养时间",@"年龄",@"体重(kg)",@"身高(cm)",@"爱好",@"讨厌",@"地址"];
    valueArr = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@""]];
    postKeyArr = @[@"id",@"name",@"variety",@"adop_time",@"age",@"weight",@"height",@"hobby",@"hate",@"address"];
    self.detaileTabView.tableHeaderView = _headView;
    imgBtnArr = @[_imgBtn1,_imgBtn2,_imgBtn3,_imgBtn4,_imgtn5];
    for (NSInteger  i = 0 ; i< imgBtnArr.count;i++) {
        UIButton *btn = imgBtnArr[i];
        btn.backgroundColor = AppThemeColor;
    }
    [self getData];
    
    self.detaileTabView.tableFooterView = [UIView new];
    
}
-(void)getData{
    NSDictionary *dic = @{@"id":_info.ID};
     [[NetworkManager sharedManager] postJSON:URL_ArchiveDetaile parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
         
         if (status == Request_Success) {
             NSLog(@"%@",responseData);
             NSDictionary *dataDic = responseData;
             valueArr = [NSMutableArray arrayWithArray:@[dataDic[@"name"],dataDic[@"variety"],dataDic[@"adop_time"],dataDic[@"age"],dataDic[@"weight"],dataDic[@"height"],dataDic[@"hobby"],dataDic[@"hate"],dataDic[@"address"]]];
             postDic = [NSMutableDictionary dictionary];
             for (NSString *keys in postKeyArr) {
                 [postDic setValue:dataDic[keys] forKey:keys];
             }
             NSArray *listArr =  dataDic[@"albums"];
             NSInteger count = MIN(listArr.count, imgBtnArr.count);
             for (NSInteger  i = 0 ; i< count;i++) {
                 UIButton *btn = imgBtnArr[i];
                 NSDictionary *dic = listArr[i];
                 [btn sd_setImageWithURL:[NSURL URLWithString:dic[@"pic_path"]] forState:0];
                 btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
                 btn.backgroundColor = AppThemeColor;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    isCanEdit = YES;
    if (isCanEdit) {
        currentIndex = indexPath.row+1;
        NSString *values = [NSString stringWithFormat:@"%@",valueArr[indexPath.row]];
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"修改内容" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
        UITextField *tefiled = [alert textFieldAtIndex:0];
        tefiled.placeholder = @"输入要修改的内容";
        tefiled.text = values;
        if (indexPath.row==3) {
            tefiled.keyboardType = UIKeyboardTypeNumberPad;
        }else if (indexPath.row==4||indexPath.row==5){
            tefiled.keyboardType = UIKeyboardTypeDecimalPad;
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        UITextField *tefiled = [alertView textFieldAtIndex:0];
        NSString *values =tefiled.text;
        NSString *keys = postKeyArr[currentIndex];
        [postDic setValue:values forKey:keys];
         [[NetworkManager sharedManager] postJSON:URL_ArchiveEdit parameters:postDic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
             if (status==Request_Success) {
                 [valueArr replaceObjectAtIndex:currentIndex-1 withObject:values];
                 [self.detaileTabView reloadData];
             }
         }];
    }
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

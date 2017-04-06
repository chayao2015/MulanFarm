//
//  CameraListVC.m
//  MulanFarm
//
//  Created by zhanbing han on 17/4/3.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "CameraListVC.h"
#import "CameraListCell.h"

@interface CameraListVC ()
{
    NSMutableArray *_dataArr;
}
@end

@implementation CameraListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"摄像头";
    
    self.addCameraBtn.layer.borderColor = AppThemeColor.CGColor;
    self.addCameraBtn.layer.borderWidth = 1;
    self.addCameraBtn.layer.cornerRadius = 10;
    [self.addCameraBtn.layer setMasksToBounds:YES];
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraBindSucc) name:kCameraBindSuccNotification object:nil]; //摄像头绑定成功
}

//摄像头绑定成功
- (void)cameraBindSucc {
    
    [self getData];
}

- (void)getData {
    
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_CameraList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            _dataArr = [CameraInfo mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
            
            [_cameraTableView reloadData];
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
    
    static NSString *ID = @"CameraListCell";
    
    CameraListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CameraListCell" owner:nil options:nil] firstObject];
    }
    
    CameraInfo *info = _dataArr[indexPath.row];
    
    cell.info = info;
    
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
        
        CameraInfo *info = _dataArr[indexPath.row];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             info.ID, @"id",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_CameraDelete parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            
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
    
    CameraInfo *info = _dataArr[indexPath.row];
    
    
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

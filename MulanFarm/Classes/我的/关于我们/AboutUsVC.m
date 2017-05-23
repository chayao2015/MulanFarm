//
//  AboutUsVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/22.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "AboutUsVC.h"
#import "AddressVC.h"

@interface AboutUsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *imgArr;
    NSArray *dataArr;
}
@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"关于我们";
    
    imgArr = @[@"about_us",@"protocal",@"locate"];
    dataArr = @[@"关于木兰农场",@"用户协议",@"地图详情"];
    
    [self initTab]; //创建TableView
}

#pragma mark - init view

- (void)initTab {
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.tableFrame style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:self.tableView];
    }
}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, WIDTH, 150)];
    bgView.backgroundColor = AppThemeColor;
    [header addSubview:bgView];
    
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2-30, 30, 60, 60)];
    headImgView.backgroundColor = [UIColor whiteColor];
    headImgView.layer.cornerRadius = 10;
    [headImgView.layer setMasksToBounds:YES];
    headImgView.image = [UIImage imageNamed:@"logoIcon"];
    [bgView addSubview:headImgView];
    
    UILabel *nickLab = [[UILabel alloc] initWithFrame:CGRectMake(0, headImgView.maxY, WIDTH, 40)];
    nickLab.text = @"木兰农场";
    nickLab.textAlignment = NSTextAlignmentCenter;
    nickLab.textColor = [UIColor whiteColor];
    nickLab.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:nickLab];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 180.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.imageView.image = [UIImage imageNamed:imgArr[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //取消选择状态
    
    NSString *title = dataArr[indexPath.row];
    
    if ([title isEqualToString:@"关于木兰农场"]) {
        
        NSDictionary *dic = [NSDictionary dictionary];
        [[NetworkManager sharedManager] postJSON:URL_AboutUs parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            
            if (status == Request_Success) {
                
                [BaseWebVC showWithContro:self withUrlStr:responseData withTitle:@"关于木兰农场" isPresent:NO];
            }
        }];
    }
    
    if ([title isEqualToString:@"用户协议"]) {
        
        NSDictionary *dic = [NSDictionary dictionary];
        [[NetworkManager sharedManager] postJSON:URL_Agreement parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            
            if (status == Request_Success) {
                
                [BaseWebVC showWithContro:self withUrlStr:responseData withTitle:@"用户协议" isPresent:NO];
            }
        }];
    }
    
    if ([title isEqualToString:@"地图详情"]) {
        
        AddressVC *vc = [[AddressVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

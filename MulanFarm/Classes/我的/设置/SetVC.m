//
//  SetVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/22.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "SetVC.h"
#import "ChangePswVC.h"
#import "ViewController.h"
#import "LoginVC.h"
#import "BaseNC.h"

@interface SetVC ()<UITableViewDataSource, UITableViewDelegate>
{
    UILabel *cacheLab;
}

@property(nonatomic,strong)NSArray *dataList;//数据源

@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"设置";
    
    _dataList = @[@"非wifi禁止观看",@"密码修改",@"清除缓存"];
    
    UIButton *navRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 80, 44)];
    [navRightBtn setTitle:@"" forState:UIControlStateNormal];
    navRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [navRightBtn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightBtn];
    
    [self initTab]; //创建TableView
}

- (void)test {
    ViewController *test = [[ViewController alloc] init];
    test.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:test animated:YES];
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
        
        self.tableView.tableFooterView = [self tableFooterView];
    }
}

- (UIView *)tableFooterView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 45)];
    
    UIButton *exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, WIDTH-30, 45)];
    exitBtn.cornerRadius = 5;
    exitBtn.backgroundColor = AppThemeColor;
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:exitBtn];
    
    return view;
}

//退出登录
- (void)exitAction {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"要退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary *dic = [NSDictionary dictionary];
        [[NetworkManager sharedManager] postJSON:URL_Logout parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            
            if (status == Request_Success) {
                
                [[UserInfo share] setUserInfo:nil]; //清除用户信息
                
                //跳转到登录页作为根视图
                BaseNC *nc = [[BaseNC alloc] initWithRootViewController:[self setLoginController]];
                [UIApplication sharedApplication].keyWindow.rootViewController = nc;
            } else {
                [Utils showToast:@"退出失败"];
            }
        }];
    }])];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - 主页

- (UITabBarController *)setTabBarController {
    
    //第一步：要获取单独控制器所在的UIStoryboard
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //第二步：获取该控制器的Identifier并赋给你的单独控制器
    UITabBarController *tabBarController = [story instantiateViewControllerWithIdentifier:@"tabBarController"];
    
    return tabBarController;
}

#pragma mark - 登录页

- (UIViewController *)setLoginController {
    //第一步：要获取单独控制器所在的UIStoryboard
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //第二步：获取该控制器的Identifier并赋给你的单独控制器
    LoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"LoginController"];
    
    [loginVC setButtonBlock:^(){
        //进入应用主界面
        [UIApplication sharedApplication].keyWindow.rootViewController = [self setTabBarController];
    }];
    
    return loginVC;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = @"settingCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //添加箭头
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1]; //cell选中背景颜色
    
    cell.textLabel.text = self.dataList[indexPath.row];
    cell.textLabel.textColor = LightBlackColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    if ([cell.textLabel.text isEqualToString:@"非wifi禁止观看"]) {
        cell.accessoryView = [[UIView alloc] init];
        
        UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH-70, 10, 50, 30)];
        switchBtn.onTintColor = AppThemeColor;
        [switchBtn setOn:YES];
        NSString *status = [[NSUserDefaults standardUserDefaults] objectForKey:@"ForbidWifiWatch"];
        switchBtn.on = [Utils isBlankString:status]?YES:NO;
        [switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switchBtn];
    }
    
    if ([cell.textLabel.text isEqualToString:@"清除缓存"]) {
        cacheLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-120, 15, 100, 20)];
        cacheLab.text = [AEFilePath folderSizeAtPath:kCachePath];
        cacheLab.textAlignment = NSTextAlignmentRight;
        cacheLab.font = [UIFont systemFontOfSize:14];
        cacheLab.textColor = LightBlackColor;
        [cell addSubview:cacheLab];
        cell.accessoryView = [[UIView alloc] init];
    }
    
    return cell;
}

- (void)switchAction:(id)sender {
    
    UISwitch *switchBtn = (UISwitch *)sender;
    if (switchBtn.on==YES) {
        NSLog(@"开");
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ForbidWifiWatch"];
    } else {
        NSLog(@"关");
        [[NSUserDefaults standardUserDefaults] setObject:@"unForbid" forKey:@"ForbidWifiWatch"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = _dataList[indexPath.row];
    
    if ([title isEqualToString:@"密码修改"]) {
        
        //第一步：要获取单独控制器所在的UIStoryboard
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        //第二步：获取该控制器的Identifier并赋给你的单独控制器
        ChangePswVC *vc = [story instantiateViewControllerWithIdentifier:@"ChangePswVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([title isEqualToString:@"清除缓存"]) {
        NSString *message = [NSString stringWithFormat:@"确定清除%@缓存吗？",[AEFilePath folderSizeAtPath:kCachePath]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSArray *files= [[NSFileManager defaultManager] subpathsAtPath:kCachePath];
                for (NSString *p in files) {
                    NSError *error;
                    NSString *path = [kCachePath stringByAppendingPathComponent:p];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utils showToast:@"缓存清除完毕"];
                    [self.tableView reloadData];
                });
            });
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
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

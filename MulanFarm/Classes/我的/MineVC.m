//
//  MineVC.m
//  YiHeYun
//
//  Created by mac on 2017/3/8.
//  Copyright © 2017年 yhy. All rights reserved.
//

#import "MineVC.h"
#import "BellListVC.h"
#import "PersonalInfoVC.h"
#import "MyWalletVC.h"
#import "AboutUsVC.h"
#import "SetVC.h"
#import "NoteCenterVC.h"

@interface MineVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *headImgView;
    UILabel *nickLab;
    
    NSArray *imgArr;
    NSArray *dataArr;
}
@end

@implementation MineVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的";
    
    imgArr = @[@"wallet",@"about",@"set",@"notes"];
    dataArr = @[@"我的钱包",@"关于我们",@"设置",@"笔记中心"];
    
    [self setNavBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfoSucc) name:kUpdateInfoSuccNotification object:nil]; //更新信息成功
}

//更新信息成功
- (void)updateInfoSucc {
    
    [headImgView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].avatar] placeholderImage:[UIImage imageNamed:@"header"]];
    nickLab.text = [Utils isBlankString:[UserInfo share].nick_name]?@"暂无昵称":[UserInfo share].nick_name;
}

- (void)setNavBar {
    
    self.bellCountLab.layer.cornerRadius = self.bellCountLab.width/2;
    [self.bellCountLab.layer setMasksToBounds:YES];
    
    self.signBtn.layer.borderWidth = 1;
    self.signBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.signBtn.layer.cornerRadius = 5;
    [self.signBtn.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//消息列表
- (IBAction)bellAction:(id)sender {
    
    
}

- (IBAction)clickBellAction:(id)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BellListVC *vc = [story instantiateViewControllerWithIdentifier:@"BellList"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//签到
- (IBAction)signAction:(id)sender {
    [[NetworkManager sharedManager] postJSON:URL_SignIn parameters:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"签到成功"];
        }
    }];
}

//个人主页
- (void)myInfoAction {
    PersonalInfoVC *vc = [[PersonalInfoVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
    
    headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 40, 70, 70)];
    [headImgView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].avatar] placeholderImage:[UIImage imageNamed:@"header"]];
    [bgView addSubview:headImgView];
    
    nickLab = [[UILabel alloc] initWithFrame:CGRectMake(headImgView.maxX+10, headImgView.y, 120, 40)];
    nickLab.text = [Utils isBlankString:[UserInfo share].nick_name]?@"暂无昵称":[UserInfo share].nick_name;
    nickLab.textAlignment = NSTextAlignmentLeft;
    nickLab.textColor = [UIColor whiteColor];
    nickLab.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:nickLab];
    
    UIButton *editInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(nickLab.x-5, nickLab.maxY, 120, 30)];
    [editInfoBtn setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    [editInfoBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
    [editInfoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editInfoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [editInfoBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -35, 0.0, 0.0)];
    [editInfoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 15)];
    [editInfoBtn addTarget:self action:@selector(myInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:editInfoBtn];
    
    UIButton *myInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-115, 65, 100, 30)];
    [myInfoBtn setImage:[UIImage imageNamed:@"arrow_right_white"] forState:UIControlStateNormal];
    [myInfoBtn setTitle:@"个人主页" forState:UIControlStateNormal];
    [myInfoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    myInfoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [myInfoBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 90, 0.0, 0.0)];
    [myInfoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0)];
    [myInfoBtn addTarget:self action:@selector(myInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:myInfoBtn];
    
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
    
    if ([title isEqualToString:@"我的钱包"]) {
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MyWalletVC *vc = [story instantiateViewControllerWithIdentifier:@"MyWallet"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([title isEqualToString:@"关于我们"]) {
        AboutUsVC *vc = [[AboutUsVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([title isEqualToString:@"设置"]) {
        SetVC *vc = [[SetVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([title isEqualToString:@"笔记中心"]) {
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NoteCenterVC *vc = [story instantiateViewControllerWithIdentifier:@"NoteCenter"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end

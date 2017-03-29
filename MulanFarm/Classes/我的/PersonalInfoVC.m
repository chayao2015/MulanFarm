//
//  PersonalInfoVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/22.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "PersonalInfoVC.h"
#import "UIImage+Additions.h"
#import "AEFilePath.h"
#import "HZBPickerView.h"

@interface PersonalInfoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImageView *_headImgView;
    UIButton *_sexBtn;
    UIButton *_areaBtn;
    UITextField *_signTF;
    CGFloat _headHeight;
    UIImagePickerController *_imagePickerC;
    
    UITextField *_nickNameTextField;
    
    NSString *headImgPath;
    NSArray  *pickerArray; //选择数据源
    NSInteger selectFlag; //选择标识
}
@end

@implementation PersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    _headHeight = 60;
    
    [self getData];
    [self initViews];
}

- (void)getData {
    
}

- (void)initViews{
    
    UIButton *navRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 80, 44)];
    [navRightBtn setTitle:@"保存" forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [navRightBtn addTarget:self action:@selector(saveMyInfoData) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightBtn];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, WIDTH, 80)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 80)];
    label.text = @"头像";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:0.137 green:0.137 blue:0.141 alpha:1.000];
    label.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:label];
    
    _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-_headHeight-15, 10, _headHeight, _headHeight)];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].avatar] placeholderImage:[UIImage imageNamed:@""]];
    _headImgView.contentMode = UIViewContentModeScaleAspectFill;
    [topView addSubview:_headImgView];
    
    UIButton *headImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(_headImgView.x, _headImgView.y, _headImgView.width,label.maxY-_headImgView.y)];
    [headImageBtn addTarget:self action:@selector(headClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:headImageBtn];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 79.5, WIDTH, .5)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.8424 green:0.8424 blue:0.8424 alpha:1.0];
    [topView addSubview:lineView1];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.maxY, WIDTH, 200)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    CGFloat tempHeight = 50;
    
    //昵称
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, tempHeight)];
    label1.text = @"昵称";
    label1.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:label1];
    
    _nickNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(label1.maxX+10, 0, WIDTH-(label1.maxX+10)-15, tempHeight)];
    _nickNameTextField.delegate = self;
    _nickNameTextField.font = [UIFont systemFontOfSize:15];
    _nickNameTextField.text = [UserInfo share].nick_name;
    _nickNameTextField.placeholder = @"请输入昵称";
    _nickNameTextField.textColor = [UIColor colorWithRed:0.349 green:0.353 blue:0.357 alpha:1.000];
    _nickNameTextField.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:_nickNameTextField];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, label1.maxY-0.5, WIDTH, .5)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.8424 green:0.8424 blue:0.8424 alpha:1.0];
    [bottomView addSubview:lineView2];
    
    //性别
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, label1.maxY, 80, tempHeight)];
    label2.text = @"性别";
    label2.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:label2];
    
    _sexBtn = [[UIButton alloc] initWithFrame:CGRectMake(label1.maxX+10, label1.maxY, WIDTH-(label1.maxX+10)-15, tempHeight)];
    _sexBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _sexBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_sexBtn setTitle:@"请选择" forState:UIControlStateNormal];
    if ([UserInfo share].gender.length==0) {
        [_sexBtn setTitle:@"请选择" forState:UIControlStateNormal];
    } else {
        [_sexBtn setTitle:[UserInfo share].gender forState:UIControlStateNormal];
    }
    _sexBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _sexBtn.backgroundColor = [UIColor clearColor];
    [_sexBtn setTitleColor:[UIColor colorWithWhite:0.267 alpha:1.000] forState:UIControlStateNormal];
    UITapGestureRecognizer *sexTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPickerView:)];
    [_sexBtn addGestureRecognizer:sexTap];
    _sexBtn.tag = 10000;
    [bottomView addSubview:_sexBtn];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, label2.maxY-0.5, WIDTH, .5)];
    lineView3.backgroundColor = [UIColor colorWithRed:0.8424 green:0.8424 blue:0.8424 alpha:1.0];
    [bottomView addSubview:lineView3];
    
    //地区
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(15, label2.maxY, 80, 50)];
    label3.text = @"地区";
    label3.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:label3];
    
    _areaBtn = [[UIButton alloc] initWithFrame:CGRectMake(label1.maxX+10, label2.maxY, WIDTH-(label1.maxX+10)-15, 50)];
    _areaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _areaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_areaBtn setTitle:@"请选择" forState:UIControlStateNormal];
    if ([UserInfo share].area.length==0) {
        [_areaBtn setTitle:@"请选择" forState:UIControlStateNormal];
    } else {
        [_areaBtn setTitle:[UserInfo share].area forState:UIControlStateNormal];
    }
    _areaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_areaBtn setTitleColor:[UIColor colorWithWhite:0.267 alpha:1.000] forState:UIControlStateNormal];
    [bottomView addSubview:_areaBtn];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(0, label3.maxY-0.5, WIDTH, .5)];
    lineView4.backgroundColor = [UIColor colorWithRed:0.8424 green:0.8424 blue:0.8424 alpha:1.0];
    [bottomView addSubview:lineView4];
    
    //个性签名
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(15, label3.maxY, 80, 50)];
    label5.text = @"个性签名";
    label5.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:label5];
    
    _signTF = [[UITextField alloc] initWithFrame:CGRectMake(label1.maxX+10, label3.maxY, WIDTH-(label1.maxX+10)-15, 50)];
    _signTF.font = [UIFont systemFontOfSize:15];
    _signTF.placeholder = @"请选择您的个性签名";
    _signTF.delegate = self;
    _signTF.textColor = [UIColor blackColor];
    _signTF.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:_signTF];
    
    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(0, label5.maxY-0.5, WIDTH, .5)];
    lineView5.backgroundColor = [UIColor colorWithRed:0.8424 green:0.8424 blue:0.8424 alpha:1.0];
    [bottomView addSubview:lineView5];
}

-(void)showPickerView:(UITapGestureRecognizer *)gestureRecognizer{
    
    [self.view endEditing:YES];
    
    NSInteger tag = gestureRecognizer.view.tag;
    
    if (tag == 10000) {
        //初始化数组
        pickerArray=@[@"男",@"女"];
        selectFlag = 1;
    }
    
    HZBPickerView *picker = [[HZBPickerView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) andDataSource:pickerArray baseView:self.view];
    picker.cancelBlock = ^()
    {
        NSLog(@"取消");
    };
    picker.doneBlock = ^(NSString *dataStr) {
        if (tag == 10000) {
            [_sexBtn setTitle:dataStr forState:UIControlStateNormal];
        }
    };
    [picker show];
}

#pragma mark - 保存修改的信息
- (void)saveMyInfoData {
    [self.view endEditing:YES];
    
    NSString *birthStr = _signTF.text;
    NSArray *birthArr = [birthStr componentsSeparatedByString:@"-"];
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    NSString *avatarStr = userDic[@"avatar"];
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
//    if ([Utils isBlankString:headImgPath]) {
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                             _nickNameTextField.text, @"name",
//                             _accountLabel.text, @"login_account",
//                             avatarStr, @"avatar",
//                             _manBtn.selected == YES?@"1":@"0", @"sex",
//                             [UserInfo share].phone, @"mobile",
//                             _signTF.text.length>0?birthArr[0]:@"", @"b_year",
//                             _signTF.text.length>0?birthArr[1]:@"", @"b_month",
//                             _signTF.text.length>0?birthArr[2]:@"", @"b_day",
//                             [UserInfo share].userID, @"member_id",
//                             nil];
//        
//        [[NetworkManager sharedManager] postJSON:URL_EditPersonalInfo parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
//            
//            [JHHJView hideLoading]; //结束加载
//            
//            if (status == Request_Success) {
//                [Utils showToast:@"更新个人资料成功"];
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }
//        }];
//    } else {
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                             @"avatar", @"type",
//                             [UserInfo share].userID, @"member_id",
//                             nil];
//        [[NetworkManager sharedManager] postJSON:URL_UploadImage parameters:dic imagePath:headImgPath completion:^(id responseData, RequestState status, NSError *error) {
//            
//            if (status == Request_Success) {
//                
//                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     _nickNameTextField.text, @"name",
//                                     _accountLabel.text, @"login_account",
//                                     responseData, @"avatar",
//                                     _manBtn.selected == YES?@"1":@"0", @"sex",
//                                     [UserInfo share].phone, @"mobile",
//                                     _signTF.text.length>0?birthArr[0]:@"", @"b_year",
//                                     _signTF.text.length>0?birthArr[1]:@"", @"b_month",
//                                     _signTF.text.length>0?birthArr[2]:@"", @"b_day",
//                                     [UserInfo share].userID, @"member_id",
//                                     nil];
//                
//                [[NetworkManager sharedManager] postJSON:URL_EditPersonalInfo parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
//                    
//                    [JHHJView hideLoading]; //结束加载
//                    
//                    if (status == Request_Success) {
//                        [Utils showToast:@"更新个人资料成功"];
//                        [self.navigationController popToRootViewControllerAnimated:YES];
//                    }
//                }];
//            } else {
//                [JHHJView hideLoading]; //结束加载
//            }
//        }];
//    }
}

#pragma mark - 头像点击
- (void)headClick{
    [self.view endEditing:YES]; //隐藏键盘
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地相册",@"拍照",  nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = YES;
            picker.delegate=self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:NO completion:^{}];
        }
            break;
        case 1:
        {
            if ([Utils isCameraPermissionOn]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.allowsEditing = YES;
                imagePickerController.delegate = self;
                
                if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                }
                [self presentViewController:imagePickerController animated:NO completion:nil];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *iconImage = info[UIImagePickerControllerEditedImage];
        _headImgView.image = iconImage;
        
        headImgPath = [AEFilePath filePathWithType:AEFilePathType_IconPath withFileName:nil];
        [UIImageJPEGRepresentation(iconImage, 0.01) writeToFile:headImgPath atomically:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

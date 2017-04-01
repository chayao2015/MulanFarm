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

#define FirstComponent 0
#define SubComponent 1
#define ThirdComponent 2

@interface PersonalInfoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIImageView *_headImgView;
    UIButton *_sexBtn;
    UIButton *_areaBtn;
    UITextField *_signTF;
    CGFloat _headHeight;
    UIImagePickerController *_imagePickerC;
    
    UITextField *_nickNameTextField;
    
    NSString *headImgPath;
    NSArray  *pickerArr; //选择数据源
    NSInteger selectFlag; //选择标识
    
    UIPickerView *addressPicker;
    NSDictionary *dict;
    
    NSArray *pickerArray;
    NSArray *subPickerArray;
    NSArray *thirdPickerArray;
    
    NSString *province; //省
    NSString *city; //市
    NSString *county; //县
    NSString *selectContent; //选择的省市县
}
@end

@implementation PersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    _headHeight = 60;
    
    [self getData];
    [self initViews];
    
    //初始化数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    pickerArray = [dict allKeys];
    province = pickerArray[0];
    if (dict[province]!=nil) {
        subPickerArray = [dict[province] allKeys];
        city = subPickerArray[0];
    } else {
        subPickerArray = nil;
    }
    if (dict[province][city]!=nil) {
        thirdPickerArray = dict[province][city];
    } else {
        thirdPickerArray = nil;
    }
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
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].avatar] placeholderImage:[UIImage imageNamed:@"header"]];
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
        [_sexBtn setTitle:[[UserInfo share].gender isEqualToString:@"0"]?@"女":@"男" forState:UIControlStateNormal];
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
    [_areaBtn setTitle:@"请选择" forState:UIControlStateNormal];
    if ([UserInfo share].area.length==0) {
        [_areaBtn setTitle:@"请选择" forState:UIControlStateNormal];
    } else {
        [_areaBtn setTitle:[UserInfo share].area forState:UIControlStateNormal];
    }
    _areaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_areaBtn setTitleColor:[UIColor colorWithWhite:0.267 alpha:1.000] forState:UIControlStateNormal];
    [_areaBtn addTarget:self action:@selector(sureSelect) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - 保存修改的信息
- (void)saveMyInfoData {
    [self.view endEditing:YES];
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _nickNameTextField.text, @"nick_name",
                         [_sexBtn.titleLabel.text isEqualToString:@"男"]?@"1":@"0", @"gender",
                         _areaBtn.titleLabel.text, @"area",
                         @"", @"address",
                         _signTF.text, @"signature",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_UpdateUserInfo parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        if (status == Request_Success) {
            [Utils showToast:@"修改信息成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateInfoSuccNotification object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [Utils showToast:@"修改信息失败"];
        }
    }];
}

-(void)showPickerView:(UITapGestureRecognizer *)gestureRecognizer{
    
    [self.view endEditing:YES];
    
    NSInteger tag = gestureRecognizer.view.tag;
    
    if (tag == 10000) {
        //初始化数组
        pickerArr=@[@"男",@"女"];
        selectFlag = 1;
    }
    
    HZBPickerView *pickerView = [[HZBPickerView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) andDataSource:pickerArr baseView:self.view];
    pickerView.cancelBlock = ^()
    {
        NSLog(@"取消");
    };
    pickerView.doneBlock = ^(NSString *dataStr) {
        if (tag == 10000) {
            [_sexBtn setTitle:dataStr forState:UIControlStateNormal];
        }
    };
    [pickerView show];
}

#pragma mark - 确定选择按钮监听
- (void)sureSelect {
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        province = pickerArray[[addressPicker selectedRowInComponent:FirstComponent]];
        city = subPickerArray[[addressPicker selectedRowInComponent:SubComponent]];
        county = thirdPickerArray[[addressPicker selectedRowInComponent:ThirdComponent]];
        if (city==nil) {
            selectContent = [NSString stringWithFormat:@"%@",province];
        } else if(county==nil) {
            selectContent = [NSString stringWithFormat:@"%@%@",province,city];
        } else {
            selectContent = [NSString stringWithFormat:@"%@%@%@",province,city,county];
        }
        [_areaBtn setTitle:selectContent forState:UIControlStateNormal];
    }];
    
    //初始化UIPickerView
    addressPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 200)];
    addressPicker.delegate = self;
    addressPicker.dataSource = self;
    [alertController.view addSubview:addressPicker];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIPickerViewDelegate、UIPickerViewDataSource协议

//确定有几组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

//确定每组的元素个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case FirstComponent:
            return pickerArray.count;
            break;
        case SubComponent:
            return subPickerArray.count;
            break;
        case ThirdComponent:
            return thirdPickerArray.count;
            break;
        default:
            break;
    }
    return 0;
}

//宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return WIDTH/3.5;
}

//绑定数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case FirstComponent:
            return pickerArray[row];
            break;
        case SubComponent:
            return subPickerArray[row];
            break;
        case ThirdComponent:
            return thirdPickerArray[row];
            break;
        default:
            break;
    }
    return nil;
}

//数据选择控制
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case FirstComponent:
            province = pickerArray[row];
            if (dict[province]!=nil) {
                subPickerArray = [dict[province] allKeys];
                city = subPickerArray[0];
                if (dict[province][city]!=nil) {
                    thirdPickerArray = dict[province][city];
                } else {
                    thirdPickerArray = nil;
                }
            } else {
                subPickerArray = nil;
                thirdPickerArray = nil;
            }
            [addressPicker selectedRowInComponent:SubComponent];
            [addressPicker reloadComponent:SubComponent];
            [addressPicker selectedRowInComponent:ThirdComponent];
            [addressPicker reloadComponent:ThirdComponent];
            break;
        case SubComponent:
            city = subPickerArray[row];
            if (dict[province][city]!=nil) {
                thirdPickerArray = dict[province][city];
            } else {
                thirdPickerArray = nil;
            }
            [addressPicker selectRow:0 inComponent:ThirdComponent animated:YES];
            [addressPicker reloadComponent:ThirdComponent];
            break;
        default:
            break;
    }
}

#pragma mark - 头像点击
- (void)headClick{
    [self.view endEditing:YES]; //隐藏键盘
    
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //本地相册
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.allowsEditing = YES;
        pickerController.delegate=self;
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerController animated:NO completion:^{}];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //拍照
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
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = info[UIImagePickerControllerEditedImage];
        NSData *data=UIImageJPEGRepresentation(image, 0.01);
        NSMutableArray *imgDataArr = [NSMutableArray array];
        [imgDataArr addObject:data];
        
        [[NetworkManager sharedManager] postJSON:URL_UploadAvatar parameters:nil imageDataArr:imgDataArr completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"上传成功"];
                _headImgView.image = image;
                NSLog(@"头像路径：%@",responseData);
            } else {
                [Utils showToast:@"上传失败"];
            }
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  RecordDetailVC.m
//  MulanFarm
//
//  Created by zhanbing han on 17/3/28.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "RecordDetailVC.h"
#import <UIButton+WebCache.h>
#import <TZImagePickerController.h>
#import "DetailesTabCell.h"
#import "HZBPickerView.h"

#define Count 5  //一行最多放几张图片
#define MaxCount 5

@interface RecordDetailVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate>
{
    NSArray *titleArr;
    NSMutableArray *valueArr;
    NSArray *imgBtnArr;
    NSMutableDictionary *postDic;
    NSArray *postKeyArr;
    BOOL isCanEdit;
    NSInteger currentIndex;
    
    NSMutableArray  *imageArr; //存放图片数据源
    NSMutableArray  *imageStr; //存放图片数据源地址
    int photoCount; //上传照片数量
    
    //有关点击头像弹出照相机还是本地图库的菜单
    UIActionSheet   *myActionSheet;
    UIActionSheet   *myActionSheet1;
    NSMutableArray *imgViewArr;
    NSString *deleteID;
}
@end

@implementation RecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"档案详情";
    
    imageArr = [NSMutableArray array];
    titleArr = @[@"姓名",@"品种",@"领养时间",@"年龄",@"体重(kg)",@"身高(cm)",@"爱好",@"讨厌",@"地址"];
    valueArr = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@""]];
    postKeyArr = @[@"id",@"name",@"variety",@"adop_time",@"age",@"weight",@"height",@"hobby",@"hate",@"address"];
    imgViewArr = [NSMutableArray array];
    self.detaileTabView.tableHeaderView = _headView;
    imgBtnArr = @[_imgBtn1,_imgBtn2,_imgBtn3,_imgBtn4,_imgtn5];
    for (NSInteger  i = 0 ; i< imgBtnArr.count;i++) {
        UIButton *btn = imgBtnArr[i];
//        btn.backgroundColor = AppThemeColor;
        [btn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *img = [[UIImageView alloc]initWithFrame:btn.bounds];
        img.tag = 1;
        img.clipsToBounds = YES;
        img.contentMode = UIViewContentModeScaleAspectFill;
        [btn addSubview:img];
        
        
    }
    [self getData];
    
    self.detaileTabView.tableFooterView = [UIView new];
    
}
- (void)longPressTouch:(UILongPressGestureRecognizer *)ttt{
    UIButton *btn = (UIButton *)ttt.view;
    
    
   
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
             UILongPressGestureRecognizer *longs;
             for (NSInteger  i = 0 ; i< 5;i++) {
                 UIButton *btn = imgBtnArr[i];
                 UIImageView *img = [btn viewWithTag:1];
                 longs = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressTouch:)];
                 if (i<listArr.count) {
                     NSDictionary *dic = listArr[i];
                     [img sd_setImageWithURL:[NSURL URLWithString:dic[@"pic_path"]]];
                     [btn setTitle:[NSString stringWithFormat:@"%@",dic[@"id"]] forState:0];

                 }else{
                     img.image = nil;
                     
                     
                 }
             }
             [self.detaileTabView reloadData];
         }
         
     }];
}

-(void)addImage:(UIButton *)btn{
    
    UIImageView *img = [btn viewWithTag:1];
    deleteID = btn.currentTitle;
    if (img.image==nil) {
        if (imageArr.count>=MaxCount) {
            //[BHUD showErrorMessage:@"亲，最多只能上传9张图片哦~~"];
            NSLog(@"亲，最多只能上传9张图片哦~~");
        } else {
            [self.view endEditing:YES];
            
            myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从本地图库获取", nil];
            myActionSheet.tag = 101;
            [myActionSheet showInView:self.view];
        }
    }else{
    myActionSheet1 = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除相册" ,nil];
    myActionSheet1.tag = 100;
    [myActionSheet1 showInView:self.view];
    }
    
    
}

#pragma mark - UIActionSheetDelegate代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag==100) {
        if (buttonIndex==0) {
            [[NetworkManager sharedManager] postJSON:URL_DeleteAlbum parameters:@{@"id":deleteID} imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
                if (status == Request_Success) {
                    [Utils showToast:@"删除成功"];
                    [self getData];
                }
            }];
        }
    }else if (actionSheet.tag==101){
        switch (buttonIndex) {
            case 0://打开照相机拍照
                [self takePhoto];
                break;
            case 1://打开本地相册
                [self LocalPhoto];
                break;
            default:
                break;
        }
    }
}

#pragma mark - 打开照相机
-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        //NSLog(@"模拟器中无法使用照相机，请在真机中使用");
    }
}

#pragma mark - 打开本地图库
-(void)LocalPhoto{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MAX(0, MaxCount-imageArr.count) delegate:self];
    // 你可以通过block或者代理，来得到用户选择的照片
    imagePickerVc.allowPickingOriginalPhoto = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *iamges, NSArray *assets, BOOL bo) {
        for (NSInteger i = 0; i < iamges.count; i++) {
            NSData *data = UIImageJPEGRepresentation(iamges[i], 0.5);
            [imageArr addObject:data];
        }
        [self postPhoto];
    }];
    
    imagePickerVc.barItemTextColor = kColorFromRGBHex(0x2a2a2a);
    [imagePickerVc.navigationBar setTitleTextAttributes:@{
                                                          NSForegroundColorAttributeName :  kColorFromRGBHex(0x2a2a2a), NSFontAttributeName:[UIFont fontWithName:@"Heiti TC" size:18]
                                                          }];
    imagePickerVc.navigationBar.tintColor = [UIColor grayColor];
    imagePickerVc.navigationBar.barTintColor = [UIColor whiteColor];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
                NSData *data = UIImageJPEGRepresentation(image, 0.2);
        [picker dismissViewControllerAnimated:YES completion:nil];
        imgViewArr = @[data];
        [self postPhoto];
    
    }
}

- (void)postPhoto{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.info.ID, @"id",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_UploadAlbum parameters:dic imageDataArr:imageArr imageName:@"imgs[]"  completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"上传成功"];
            
            [self getData];
        }
    }];
}
#pragma mark - 照片选取取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //[picker dismissViewControllerAnimated:YES completion:nil];
    if ([picker isKindOfClass:[TZImagePickerController class]]) {
        TZImagePickerController *pc = (TZImagePickerController *)picker;
        [pc hideProgressHUD];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"DetailesTabCell";
    
    DetailesTabCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailesTabCell" owner:nil options:nil] firstObject];
    }
    
    cell.nameLab.text = titleArr[indexPath.row];
    cell.valueLab.text = [NSString stringWithFormat:@"%@",valueArr[indexPath.row]];
    
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

@end

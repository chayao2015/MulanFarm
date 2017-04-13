//
//  AddCameraVC.m
//  MulanFarm
//
//  Created by zhanbing han on 17/4/2.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "AddCameraVC.h"

@interface AddCameraVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *_imagePickerC;
    
    NSMutableArray *imgDataArr;
}
@end

@implementation AddCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加摄像头";
    
    imgDataArr = [NSMutableArray array];
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

- (IBAction)picClickAction:(id)sender {
    
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
        
        [imgDataArr removeAllObjects];
        
        UIImage *image = info[UIImagePickerControllerEditedImage];
        NSData *data=UIImageJPEGRepresentation(image, 0.01);
        [imgDataArr addObject:data];
        
        _addPicImgView.image = image;
    });
}

- (IBAction)bindingCameraAction:(id)sender {
    
    [self.view endEditing:YES];
    
//    if (imgDataArr.count<=0) {
//        [Utils showToast:@"请上传摄像头图片"];
//        return;
//    }
    
    if ([Utils isBlankString:_numberTF.text]) {
        [Utils showToast:@"请输入摄像头编号"];
        return;
    }
    
    if ([Utils isBlankString:_nameTF.text]) {
        [Utils showToast:@"请输入摄像头名称"];
        return;
    }
    
    if ([Utils isBlankString:_pswTF.text]) {
        [Utils showToast:@"请输入摄像头密码"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _numberTF.text, @"camera_no",
                         _nameTF.text, @"name",
                         _pswTF.text,@"camera_device_pwd",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_CameraBind parameters:dic imageDataArr:imgDataArr imageName:@"thumbnail[]" completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"绑定成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kCameraBindSuccNotification object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end

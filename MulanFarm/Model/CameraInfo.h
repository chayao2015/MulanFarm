//
//  CameraInfo.h
//  MulanFarm
//
//  Created by zhanbing han on 17/4/3.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraInfo : NSObject

@property (nonatomic,copy) NSString *ID; //摄像头ID
@property (nonatomic,copy) NSString *archive_id; //对应档案ID
@property (nonatomic,copy) NSString *name; //摄像头名称
@property (nonatomic,copy) NSString *thumbnail; //摄像头缩略图
@property (nonatomic,copy) NSString *create_date; //创建日期
@property (nonatomic,copy) NSString *user_id; //用户ID
@property (nonatomic,copy) NSString *is_bound; //是否绑定
@property (nonatomic,copy) NSString *is_selected; //是否选中

@property (nonatomic,copy) NSString *camera_user_name; //摄像头用户名
@property (nonatomic,copy) NSString *camera_user_pswd; //摄像头用户密码
@property (nonatomic,copy) NSString *camera_no; //摄像头编号
@property (nonatomic,copy) NSString *camera_device_pwd; //摄像头密码

@end

//
//  ServerUrl.h
//  ArtEast
//
//  Created by yibao on 16/9/30.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#ifndef ServerUrl_h
#define ServerUrl_h

#define AESSecret @"F$0.%a~+r^#=`M|?" //加密密钥

#pragma mark - ---------------接口地址---------------

#define ProductUrl @"http://120.27.212.121/farm/controller/api/"
#define WebUrl @"http://www.cydf.com/"
#define PictureUrl @"http://images-app.cydf.com/"


#pragma mark - ---------------接口名称---------------

#define URL_Login @"user.php?m=login" //登录
#define URL_Register @"user.php?m=reg" //注册
#define URL_UpdateUserInfo @"user.php?m=updateProfile" //修改信息
#define URL_SignIn @"user.php?m=signIn" //签到

#endif /* ServerUrl_h */

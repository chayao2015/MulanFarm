//
//  UserInfo.h
//  ArtEast
//
//  Created by yibao on 16/9/30.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  用户Modle
 *
 */

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic,copy) NSString *access_token;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *create_date;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *end_date;
@property (nonatomic,copy) NSString *gender;

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *levle;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *nick_name;
@property (nonatomic,copy) NSString *open_id;

@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *qq;
@property (nonatomic,copy) NSString *signature;
@property (nonatomic,copy) NSString *start_date;
@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *user_name;
@property (nonatomic,copy) NSString *user_pwd;
@property (nonatomic,copy) NSString *wechat;

+ (UserInfo *)share;

- (NSDictionary *)getUserInfo;

- (void)setUserInfo:(NSDictionary *)userDic;

@end

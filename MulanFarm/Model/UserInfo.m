//
//  UserInfo.m
//  ArtEast
//
//  Created by yibao on 16/9/30.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "UserInfo.h"

static UserInfo *_userInfo = nil;
static NSUserDefaults *_defaults = nil;

@implementation UserInfo

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo = [[UserInfo alloc] init];
        _defaults = [NSUserDefaults standardUserDefaults];
    });
    return _userInfo;
}

- (void)getUserInfo {
    
    NSDictionary *userDic = [_defaults objectForKey:@"UserInfo"];
    if (userDic) {
        [self loadUserDic:userDic];
    }
}

- (void)setUserInfo:(NSDictionary *)userDic {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userDic forKey:@"UserInfo"];
    [defaults synchronize];
    
    [self loadUserDic:userDic];
}

- (void)loadUserDic:(NSDictionary *)userDic {
    
    self.access_token = userDic[@"access_token"];;
    self.address = userDic[@"address"];;
    self.area = userDic[@"area"];;
    self.avatar = userDic[@"avatar"];;
    self.create_date = userDic[@"create_date"];;
    self.email = userDic[@"email"];;
    self.end_date = userDic[@"end_date"];;
    self.gender = userDic[@"gender"];;
    
    self.ID = userDic[@"id"];;
    self.levle = userDic[@"levle"];;
    self.name = userDic[@"name"];;
    self.nick_name = userDic[@"nick_name"];;
    self.open_id = userDic[@"open_id"];;
    
    self.phone = userDic[@"phone"];;
    self.qq = userDic[@"qq"];;
    self.signature = userDic[@"signature"];;
    self.start_date = userDic[@"start_date"];;
    self.status = userDic[@"status"];;
    
    self.user_name = userDic[@"user_name"];;
    self.user_pwd = userDic[@"user_pwd"];;
    self.wechat = userDic[@"wechat"];
}

@end

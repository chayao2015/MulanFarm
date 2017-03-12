//
//  NetworkManager.m
//  ArtEast
//
//  Created by yibao on 16/9/28.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking.h>
#import "NetworkUtil.h"
#import "Utils.h"
#import "NSDictionary+DeleteNULL.h"

#define TIMEOUT 20;

static NetworkManager *_manager = nil;

@implementation NetworkManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:ProductUrl]];
    });
    return _manager;
}

- (void)postJSON:(NSString *)name
      parameters:(NSDictionary *)parameters
       imagePath:(NSString *)imagePath
      completion:(RequestCompletion)completion {
    
    [self configNetManager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ProductUrl,name];
    
    [self POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id _Nullable object = [NSDictionary changeType:responseObject];
        NSLog(@"参数%@%@\n%@返回结果：%@",urlStr,parameters,name,object);
        
        NSString *result = [NSString stringWithFormat:@"%@",object[@"result"]];
        if ([result isEqualToString:@"1"]) { //成功
            id _Nullable dataObject = object[@"data"];
            completion(dataObject,Request_Success,nil);
        } else {
            completion(nil,Request_Fail,nil);
            [Utils showToast:object[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil,Request_TimeoOut,error);
        NSLog(@"参数%@%@\n%@请求失败信息：%@错误码：%ld",urlStr,parameters,name,[error localizedDescription],(long)[error code]);
        [Utils showToast:@"请求超时"];
        [JHHJView hideLoading]; //结束加载
    }];
    
//    [self POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        if ([imagePath length] > 0) {
//            NSURL *filePath = [NSURL fileURLWithPath:imagePath];
//            [formData appendPartWithFileURL:filePath name:@"file" error:nil];
//        }
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        id _Nullable object = [NSDictionary changeType:responseObject];
//        NSLog(@"参数%@%@\n%@返回结果：%@",urlStr,parameters,name,object);
//        
//        NSString *result = [NSString stringWithFormat:@"%@",object[@"result"]];
//        if ([result isEqualToString:@"1"]) { //成功
//            id _Nullable dataObject = object[@"data"];
//            completion(dataObject,Request_Success,nil);
//        } else {
//            completion(nil,Request_Fail,nil);
//            [Utils showToast:object[@"msg"]];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        completion(nil,Request_TimeoOut,error);
//        NSLog(@"参数%@%@\n%@请求失败信息：%@错误码：%ld",urlStr,parameters,name,[error localizedDescription],(long)[error code]);
//        [Utils showToast:@"请求超时"];
//        [JHHJView hideLoading]; //结束加载
//    }];
}

- (void)getJSON:(NSString *)name
     parameters:(NSDictionary *)parameters
     completion:(RequestCompletion)completion {
    
    [self configNetManager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ProductUrl,name];
    
    [self GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id _Nullable object = [NSDictionary changeType:responseObject];
        if ([object[@"result"] isEqualToString:@"true"]) { //成功
            id _Nullable dataObject = object[@"data"];
            if ([dataObject isKindOfClass:[NSString class]]) {
                completion(@"",Request_Success,nil);
            } else {
                completion(dataObject,Request_Success,nil);
            }
        } else {
            completion(nil,Request_Fail,nil);
            [Utils showToast:object[@"msg"]];
        }
        NSLog(@"参数%@%@\n%@返回结果：%@",urlStr,parameters,name,object);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil,Request_TimeoOut,error);
        NSLog(@"参数%@%@\n%@请求失败信息：%@",urlStr,parameters,name,[error localizedDescription]);
        [Utils showToast:@"请求超时"];
        [JHHJView hideLoading]; //结束加载
    }];
}

//配置请求头
- (void)configNetManager {
    //请求
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestSerializer.timeoutInterval = TIMEOUT;
    //响应
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    //response.removesKeysWithNullValues = YES;
    self.responseSerializer = response;
    self.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/json", nil];
    
    if ([Utils isUserLogin]) {
        NSLog(@"access_token值：%@",[UserInfo share].access_token);
        [self.requestSerializer setValue:[UserInfo share].access_token forHTTPHeaderField:@"accesstoken"];
    }
}

@end

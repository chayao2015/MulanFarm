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
    
    NSMutableDictionary *params = [parameters mutableCopy];
    
    [params setObject:name forKey:@"method"];
    [params setObject:[Utils getCurrentTime] forKey:@"date"];
    [params setObject:@"true" forKey:@"direct"];
    //获取本地app当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [NSString stringWithFormat:@"%@",infoDic[@"CFBundleShortVersionString"]];
    [params setObject:currentVersion forKey:@"version"];
    [params setObject:[self getSign:params] forKey:@"sign"];
    
    [self POST:ProductUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if ([imagePath length] > 0) {
            NSURL *filePath = [NSURL fileURLWithPath:imagePath];
            [formData appendPartWithFileURL:filePath name:@"file" error:nil];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id _Nullable object = [NSDictionary changeType:responseObject];
        NSLog(@"参数%@%@\n%@返回结果：%@",ProductUrl,params,name,object);
        
        if ([object[@"rsp"] isEqualToString:@"succ"]) { //成功
            id _Nullable dataObject = object[@"data"];
            completion(dataObject,Request_Success,nil);
        } else {
            completion(nil,Request_Fail,nil);
            [Utils showToast:object[@"res"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil,Request_TimeoOut,error);
        NSLog(@"参数%@%@\n%@请求失败信息：%@",ProductUrl,params,name,[error localizedDescription]);
        [Utils showToast:@"请求超时"];
        [JHHJView hideLoading]; //结束加载
    }];
}

- (void)getJSON:(NSString *)name
     parameters:(NSDictionary *)parameters
     completion:(RequestCompletion)completion {
    
    [self configNetManager];
    
    NSMutableDictionary *params = [parameters mutableCopy];
    [params setObject:name forKey:@"method"];
    [params setObject:[Utils getCurrentTime] forKey:@"date"];
    [params setObject:@"true" forKey:@"direct"];
    [params setObject:[self getSign:params] forKey:@"sign"];
    
    [self GET:ProductUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id _Nullable object = [NSDictionary changeType:responseObject];
        if ([object[@"rsp"] isEqualToString:@"succ"]) { //成功
            id _Nullable dataObject = object[@"data"];
            if ([dataObject isKindOfClass:[NSString class]]) {
                completion(@"",Request_Success,nil);
            } else {
                completion(dataObject,Request_Success,nil);
            }
        } else {
            completion(nil,Request_Fail,nil);
            [Utils showToast:object[@"res"]];
        }
        NSLog(@"参数%@%@\n%@返回结果：%@",ProductUrl,params,name,object);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil,Request_TimeoOut,error);
        NSLog(@"参数%@%@\n%@请求失败信息：%@",ProductUrl,params,name,[error localizedDescription]);
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
    self.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
}

//签名
- (NSString *)getSign:(NSMutableDictionary *)dict {
    
    NSString *signStr = @"";
    
    //1、字典根据key按照升序排序，然后KeyValue拼接成字符串
    NSArray *keys = [dict allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];

    for (NSString *categoryId in sortedArray) {
        signStr = [[signStr stringByAppendingString:categoryId] stringByAppendingString:[NSString stringWithFormat:@"%@",[dict objectForKey:categoryId]]];
    }
    
    NSLog(@"%@",signStr);
    
    //2、Md5加密并转化成大写
    signStr = [[Utils md5HexDigest:signStr] uppercaseString];
    
    //3、拼接screct
    signStr = [signStr stringByAppendingString:AppSecret];
    
    //4、再次Md5加密并转化成大写
    signStr = [[Utils md5HexDigest:signStr] uppercaseString];
    
    return signStr;
}

@end

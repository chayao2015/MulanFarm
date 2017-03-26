//
//  Articleinfo.m
//  MulanFarm
//
//  Created by zyl on 17/3/25.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "Articleinfo.h"

@implementation Articleinfo

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id",
             @"detailUrl":@"url",
             };
}

@end

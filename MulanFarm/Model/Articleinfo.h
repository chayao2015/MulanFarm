//
//  Articleinfo.h
//  MulanFarm
//
//  Created by zyl on 17/3/25.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Articleinfo : NSObject

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *thumbnail;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *detailUrl;
@property (nonatomic,copy) NSString *update_time;
@property (nonatomic,copy) NSString *create_date;

@end

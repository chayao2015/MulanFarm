//
//  NoteInfo.h
//  MulanFarm
//
//  Created by zyl on 17/3/25.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteInfo : NSObject

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *create_date;

@end

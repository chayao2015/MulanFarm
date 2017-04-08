//
//  BackProtocol.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/23.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CameraInfo.h"

@protocol BackProtocol <NSObject>

@optional
- (void)backAction:(CameraInfo *)info;

@end

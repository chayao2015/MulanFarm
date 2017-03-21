//
//  ZBTextField.m
//  MulanFarm
//
//  Created by zyl on 17/3/21.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "ZBTextField.h"

@implementation ZBTextField

// 重写此方法
-(void)drawPlaceholderInRect:(CGRect)rect {
    // 计算占位文字的 Size
    CGSize placeholderSize = [self.placeholder sizeWithAttributes:
                              @{NSFontAttributeName : self.font}];
    
    [self.placeholder drawInRect:CGRectMake(0, (rect.size.height - placeholderSize.height)/2, rect.size.width, rect.size.height) withAttributes:
     @{NSForegroundColorAttributeName : [UIColor whiteColor],
       NSFontAttributeName : self.font}];
}

@end

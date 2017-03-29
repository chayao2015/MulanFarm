//
//  HZBPickerView.h
//  HuiYangChe_ForMechanic
//
//  Created by zhanbing han on 16/1/25.
//  Copyright (c) 2015年 北京与车行信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^doneAction)(NSString *dataStr);

@interface HZBPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString *getData;
    CGRect myFrame;
    UIPickerView *picker;
    NSMutableArray *dataArr;
}

@property (nonatomic, copy) dispatch_block_t cancelBlock;
@property (nonatomic, copy) doneAction doneBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock; //点击左右按钮都会触发该消失的block

@property (nonatomic,retain) UIView *baseView;

/**
 *  初始化函数
 *
 *  @param frame 视图的位置
 *  @param data  数组
 *  @param bView self.view
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
      andDataSource:(NSArray *)data
           baseView:(UIView *)bView;

/**
 *  显示视图
 */
-(void)show;

@end

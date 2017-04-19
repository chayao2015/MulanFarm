//
//  HZBPickerDate.h
//  HuiYangChe_ForMechanic
//
//  Created by zhanbing han on 16/1/26.
//  Copyright © 2016年 北京与车行信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

typedef void(^doneAction)(NSString *dateStr);

@interface HZBDatePicker : UIView
{
    UIDatePicker *datePicker;// 日历控件
    NSString *getDate; //获得的日期
    CGRect myFrame;
}

@property (nonatomic, copy) dispatch_block_t cancelBlock;
@property (nonatomic, copy) doneAction doneBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock; //点击左右按钮都会触发该消失的block

@property (nonatomic,copy) NSString *leftTitle;
@property (nonatomic,copy) NSString *rigthTitle;
@property (nonatomic,retain) UIView *baseView;

/**
 *  构造方法
 *
 *  @param frame      视图尺寸
 *  @param leftTitle  左按钮标题
 *  @param rigthTitle 右按钮标题
 *  @param bView      self.view
 *
 *  @return id
 */
- (id)initWithFrame:(CGRect)frame
          leftTitle:(NSString *)leftTitle
         rightTitle:(NSString *)rigthTitle
           baseView:(UIView *)bView;

/**
 *  显示视图
 */
-(void)show;

@end

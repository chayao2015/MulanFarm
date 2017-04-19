//
//  HZBPickerDate.m
//  HuiYangChe_ForMechanic
//
//  Created by zhanbing han on 16/1/26.
//  Copyright © 2016年 北京与车行信息技术有限公司. All rights reserved.
//

#import "HZBDatePicker.h"

@interface HZBDatePicker ()
{
    UIView *bgView;
}
@end

@implementation HZBDatePicker

- (id)initWithFrame:(CGRect)frame
          leftTitle:(NSString *)leftTitle
         rightTitle:(NSString *)rigthTitle
           baseView:(UIView *)bView{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        
        myFrame = frame;
        self.leftTitle = leftTitle;
        self.rigthTitle = rigthTitle;
        self.baseView = bView;
        
        [self.baseView addSubview:self];
        [self initView]; //初始化视图
    }
    return self;
}

#pragma mark - 初始化视图
- (void)initView {
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, myFrame.size.height, ScreenWidth, 250)];
    [self.baseView addSubview:bgView];
    
    UIView *pickDateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    pickDateView.backgroundColor = [UIColor colorWithRed:0.9373 green:0.9373 blue:0.9373 alpha:1.0];
    [bgView addSubview:pickDateView];
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 150, 40)];
    cancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancel setTitle:self.leftTitle forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithRed:0.136 green:0.4057 blue:0.8865 alpha:1.0] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancel];
    
    UIButton *sure = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-170, 0, 150, 40)];
    [sure setTitleColor:[UIColor colorWithRed:0.136 green:0.4057 blue:0.8865 alpha:1.0] forState:UIControlStateNormal];
    sure.titleLabel.font = [UIFont systemFontOfSize:17];
    [sure addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    sure.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sure setTitle:self.rigthTitle forState:UIControlStateNormal];
    [bgView addSubview:sure];
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, WIDTH, 200)];
    datePicker.backgroundColor = [UIColor whiteColor];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    datePicker.locale = locale;
    [datePicker addTarget:self action:@selector(getActivityDate:) forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:datePicker];
    
    //默认值
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    datePicker.datePickerMode = UIDatePickerModeDate;
    getDate = [fmt stringFromDate:[datePicker date]];
}

#pragma mark   UIDatePicker得到日期控件中的日期
- (void)getActivityDate:(UIDatePicker *)dataPicker
{
    NSDate *selected = [dataPicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    getDate = [dateFormatter stringFromDate:selected];
}

#pragma mark - 取消点击
- (void)cancelAction:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
    [self dismissAlert];
}

#pragma mark - 确定点击
- (void)doneAction:(id)sender {
    if (self.doneBlock) {
        self.doneBlock(getDate);
    }
    
    [self dismissAlert];
}

#pragma mark - 页面消失
- (void)dismissAlert
{
    [self dismiss];
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

#pragma mark - 视图显示
-(void)show
{
    [UIView animateWithDuration:0.5 delay:0.2 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        CGRect bgViewFrame = bgView.frame;
        bgViewFrame.origin.y = myFrame.size.height-240;
        bgView.frame = bgViewFrame;
        
    } completion:nil];
}

#pragma mark - 视图隐藏
-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect bgViewFrame = bgView.frame;
        bgViewFrame.origin.y = myFrame.size.height;
        bgView.frame = bgViewFrame;
        
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
    }];
}

@end

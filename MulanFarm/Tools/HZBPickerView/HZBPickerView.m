//
//  HZBPickerView.m
//  HuiYangChe_ForMechanic
//
//  Created by zhanbing han on 16/1/25.
//  Copyright (c) 2015年 北京与车行信息技术有限公司. All rights reserved.
//

#import "HZBPickerView.h"

@interface HZBPickerView ()
{
    UIView *bgView; //模糊背景视图
}
@end

@implementation HZBPickerView

- (id)initWithFrame:(CGRect)frame
      andDataSource:(NSArray *)data
           baseView:(UIView *)bView {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        
        myFrame = frame;
        dataArr = [NSMutableArray arrayWithArray:data];
        if (dataArr.count>0) {
            getData = dataArr[0]; //默认选择第一个
        }
        self.baseView = bView;
        
        [self.baseView addSubview:self];
        [self initView];
    }
    return self;
}

- (void)initView {
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, myFrame.size.height, WIDTH, 250)];
    [self.baseView addSubview:bgView];
    
    picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, bgView.frame.size.height-40)];
    picker.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    picker.dataSource = self;
    [bgView addSubview:picker];
    UIView *pickDateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    pickDateView.backgroundColor = [UIColor colorWithRed:0.9373 green:0.9373 blue:0.9373 alpha:1.0];
    [bgView addSubview:pickDateView];
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 150, 40)];
    cancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithRed:0.0 green:0.3843 blue:0.7529 alpha:1.0] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancel];
    
    UIButton *sure = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-160, 0, 150, 40)];
    [sure setTitleColor:[UIColor colorWithRed:0.0 green:0.3098 blue:0.7333 alpha:1.0] forState:UIControlStateNormal];
    sure.titleLabel.font = [UIFont systemFontOfSize:17];
    [sure addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    sure.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [bgView addSubview:sure];
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return dataArr.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return WIDTH;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view) {
        view = [[UIView alloc] init];
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = dataArr[row];
    label.font = [UIFont systemFontOfSize:20];
    [view addSubview:label];
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    getData = dataArr[row];
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
        self.doneBlock(getData);
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
        bgViewFrame.origin.y = myFrame.size.height-186;
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

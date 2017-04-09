//
//  SignView.m
//  MulanFarm
//
//  Created by zhanbing han on 17/4/9.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "SignView.h"

@interface SignView ()
{
    UIView      *_mainView;
    UIButton    *_doneBtn;
}
@end

@implementation SignView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        
        [self setUp];
    }
    
    return  self;
}

- (void)setUp{
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(50, (HEIGHT-WIDTH+100)/2, WIDTH-100, 160)];
    _mainView.layer.cornerRadius = 10;
    _mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_mainView];
    
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_mainView.width/2-20, 15, 40, 40)];
    iconImgView.image = [UIImage imageNamed:@"surport"];
    [_mainView addSubview:iconImgView];
    
    UILabel *signLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, _mainView.width, 20)];
    signLab.text = @"签到成功！继续加油吧！";
    signLab.textColor = [UIColor darkGrayColor];
    signLab.font = [UIFont boldSystemFontOfSize:16];
    signLab.textAlignment = NSTextAlignmentCenter;
    [_mainView addSubview:signLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _mainView.height-45, _mainView.width, 1)];
    lineView.backgroundColor = AppThemeColor;
    [_mainView addSubview:lineView];
    
    //我知道了
    _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _mainView.height-44, _mainView.width, 44)];
    [_doneBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    _doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_doneBtn];
}

#pragma mark - methods

//显示动画
- (void)showAnimation {
    _mainView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _mainView.alpha = 1;
    } completion:nil];
}

//消失动画
- (void)hideAnimation {
    [UIView animateWithDuration:0.2 animations:^{
        _mainView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//我知道了
- (void)doneAction {
    
    [self hideAnimation];
    
    if (self.doneBlock) {
        self.doneBlock();
    }
}

@end

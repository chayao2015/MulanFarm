//
//  GuidePageVC.m
//  YiHeYun
//
//  Created by mac on 2017/3/8.
//  Copyright © 2017年 yhy. All rights reserved.
//

#import "GuidePageVC.h"

@interface GuidePageVC ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIImageView *slogonImg;

@end

@implementation GuidePageVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *imageArr = @[@"引导1.jpg", @"引导2.jpg", @"引导3.jpg"];
    self.scrollView.contentSize = CGSizeMake(WIDTH * imageArr.count, HEIGHT);
    
    for (int i = 0; i< imageArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        [imgView setImage:[UIImage imageNamed:imageArr[i]]];
        [imgView setContentMode:UIViewContentModeScaleAspectFill];
        imgView.clipsToBounds=YES;
        imgView.exclusiveTouch=YES;
        imgView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imgView];
        if (i==2) {
            //立即体验
            UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, HEIGHT-120, WIDTH-100, 60)];
            enterBtn.backgroundColor = [UIColor clearColor];
            [enterBtn addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:enterBtn];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate =self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)enterAction {
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FirstLG"];
    
    if (self.buttonBlock) {
        self.buttonBlock();
    }
}

#pragma mark - UIScrollViewDelegate协议
//减速滑动(Decelerating:使减速的)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage = fabs(scrollView.contentOffset.x)/WIDTH; //计算当前页
    
    if (currentPage==3) {
        [UIView animateWithDuration:2 animations:^{
            _slogonImg.alpha = 1;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

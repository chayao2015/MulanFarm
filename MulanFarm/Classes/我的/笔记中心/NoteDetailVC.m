//
//  NoteDetailVC.m
//  MulanFarm
//
//  Created by zhanbing han on 17/4/2.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "NoteDetailVC.h"

@interface NoteDetailVC ()

@end

@implementation NoteDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的笔记";
    
    [self initView];
}

- (void)initView {
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 74, WIDTH-30, 30)];
    titleLab.text = self.info.title;
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textColor = [UIColor colorWithWhite:0.055 alpha:1.000];
    [self.view addSubview:titleLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, titleLab.maxY, WIDTH-30, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:0.898 green:0.902 blue:0.906 alpha:1.000];
    [self.view addSubview:lineView];
    
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(13, lineView.maxY+5, WIDTH-30, HEIGHT-110)];
    txtView.textColor = [UIColor colorWithRed:0.298 green:0.298 blue:0.306 alpha:1.000];
    txtView.text = [NSString stringWithFormat:@"        %@",self.info.content];
    txtView.font = [UIFont systemFontOfSize:14];
    txtView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:txtView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

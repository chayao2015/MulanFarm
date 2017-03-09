//
//  BaseVC.m
//  ArtEast
//
//  Created by yibao on 16/9/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "BaseVC.h"
#import "MJRefresh.h"
#import <JPUSHService.h>

@interface BaseVC ()
{
    __block int timeout; //倒计时时间
}

@property (nonatomic, assign)CGFloat viewBottom; //textField的底部
@property (nonatomic, assign)CGRect keyBoardFrames;

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    ;
    self.view.backgroundColor = PageColor;
    self.navigationController.navigationBar.hidden = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.tableFrame = CGRectMake(0, 64, WIDTH, HEIGHT-64);

    [self setNavBar];
    
    __weak id weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    
    //无网络通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkDisappear) name:@"kNetDisAppear" object:nil];
    //有网络通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkAppear) name:@"kNetAppear" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//没有网络了
- (void)netWorkDisappear
{
//    if (![self.navItem.title containsString:@"（未连接）"]) {
//        self.navItem.title = [NSString stringWithFormat:@"%@（未连接）",self.navItem.title];
//    }
}

//有网络了
- (void)netWorkAppear
{
//    if ([self.navItem.title containsString:@"（未连接）"]) {
//        self.navItem.title = [self.navItem.title stringByReplacingOccurrencesOfString:@"（未连接）" withString:@""];
//    }
}

#pragma mark - 自定义导航条
- (void)setNavBar {
    
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64.0)];
    self.navBar.translucent = NO;
    
    self.navItem = [[UINavigationItem alloc] init];
    [self.navBar setItems:@[self.navItem]];
    
    if ([[self.navigationController viewControllers] count] == 1) {
        
    } else {
        UIButton *bb = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
        [bb setImage:[UIImage imageNamed:@"backIcon"] forState:0];
        bb.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [bb addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bb];;
//        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navItem.leftBarButtonItem = backBarButtonItem;
    }
}

#pragma mark - Set方法

- (void)setTitle:(NSString *)title {
    self.navItem.title = title;
}

#pragma mark - 自定义方法

//返回
- (void)backAction {
    timeout = -1;
    [self.navigationController popViewControllerAnimated:YES];
    
}

//获取数据
- (void)getData{
    
}

#pragma mark - 动画下拉刷新/上拉加载更多
- (void)tableViewGifHeaderWithRefreshingBlock:(void(^)()) block {
    
    //设置即将刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSInteger i = 1; i<=21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_refresh_image_0%zd",i]];
        [refreshingImages addObject:image];
    }
    
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        //下拉刷新要做的操作
        block();
    }];
    
    //是否显示刷新状态和刷新时间
    gifHeader.stateLabel.hidden = YES;
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    
    [gifHeader setImages:@[refreshingImages[0]] forState:MJRefreshStateIdle];
    [gifHeader setImages:refreshingImages forState:MJRefreshStatePulling];
    [gifHeader setImages:refreshingImages forState:MJRefreshStateRefreshing];
    _tableView.mj_header = gifHeader;
}

- (void)tableViewGifFooterWithRefreshingBlock:(void(^)()) block {
    
    NSMutableArray *footerImages = [NSMutableArray array];
    for (int i = 1; i <= 21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_refresh_image_0%zd",i]];
        [footerImages addObject:image];
    }
    
    MJRefreshAutoGifFooter *gifFooter = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        //上拉加载需要做的操作
        block();
    }];
    
    //是否显示刷新状态和刷新时间
    //gifFooter.stateLabel.hidden = YES;
    //gifFooter.refreshingTitleHidden = YES;
    
    [gifFooter setImages:@[footerImages[0]] forState:MJRefreshStateIdle];
    [gifFooter setImages:footerImages forState:MJRefreshStateRefreshing];
    _tableView.mj_footer = gifFooter;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = [textField.superview convertRect:textField.frame toView:self.view];
    self.tempFrame = frame;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    CGRect frame = [textView.superview convertRect:textView.frame toView:self.view];
    self.tempFrame = frame;
}

- (void)keyboardWillChangeFrame:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    
    CGFloat duration = [dict[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect keyboardFrame = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat transformY = 0;
    _keyBoardFrames = keyboardFrame;
    if (keyboardFrame.origin.y<self.tempFrame.origin.y + self.tempFrame.size.height) {
        transformY = keyboardFrame.origin.y - self.tempFrame.origin.y - self.tempFrame.size.height-30;
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
        self.navBar.frame = CGRectMake(0, -transformY, WIDTH, 64);
        [self.view bringSubviewToFront:self.navBar];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //隐藏系统导航条
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.navBar];
    
    if (!self.isPanForbid) { //默认开启
        // 开启iOS自带侧滑返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    } else {
        // 禁用iOS自带侧滑返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:self.navBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //显示系统导航条
//    [self.navigationController setNavigationBarHidden:NO];
    [JHHJView hideLoading]; //结束加载
}

- (void)dealloc {
    NSLog(@"释放控制器");
    [[NSNotificationCenter defaultCenter] removeObserver:self]; //移除通知
    timeout = -1;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"item name = %@", item.title);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    
}

- (void)startTimeCount:(UIButton *)l_timeButton {
    timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [l_timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                l_timeButton.userInteractionEnabled = YES;
                l_timeButton.enabled = YES;
            });
        }else{
            int seconds = timeout;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [l_timeButton setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                l_timeButton.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

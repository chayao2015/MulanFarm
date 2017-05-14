//
//  FarmVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/9.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "FarmVC.h"
#import "BellListVC.h"
#import "MD5.h"
#import "P2PClient.h"
#import "OpenGLView.h"
#import "Util.h"
#import "BackProtocol.h"
#import "CameraListVC.h"
#import "ArchiveInfo.h"
#import "RecordDetailVC.h"
#import "SignView.h"
#import "NetworkUtil.h"

//以下是 用户账号密码 设备id和密码,不保证一直有用,请使用您自己的账号密码和设备
#define UserName @"0810090"
#define UserPswd @"111222"
#define DeviceId @"7019032"
#define DevicePw @"abc123"

@interface FarmVC ()<P2PClientDelegate,BackProtocol>{
    NSString* _p2pcode1;
    NSString* _p2pcode2;
    NSString* _userIDName;//用户的id号
    BOOL _hadInitDevice;//是否连接设备
    BOOL _hadLogin;//是否成功登录
    BOOL _isReject;//是否挂断了
    
    OpenGLView *_remoteView;//监控画面
    UILabel *_tipLab; //监控提示
    UIButton *_switchBtn; //切换横竖屏
    
    /**
     这个错误提示是来自P2PCInterface.h里的 dwErrorOption枚举,
     写在这里只是为了更好的展示错误信息,实际开发的时候请不要像我这样用这种不好的编程习惯
     */
    NSArray<NSString*>* _errorStrings;
    
    CameraInfo *cameraInfo;
    
    BOOL _enterStatus; //从后台进入前台状态
}

@end

@implementation FarmVC

-(void)createMonitoView{

    CGRect rect=CGRectMake(0, 104, WIDTH, 160);
    
    _remoteView = [[OpenGLView alloc] init];
    _remoteView.frame = rect;
    _remoteView.backgroundColor=[UIColor blackColor];
    _remoteView.hidden = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:_remoteView];
    
    _tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 160)];
    _tipLab.text = @"加载中...";
    _tipLab.textColor = [UIColor whiteColor];
    _tipLab.font = [UIFont systemFontOfSize:14];
    _tipLab.textAlignment = NSTextAlignmentCenter;
    [_remoteView addSubview:_tipLab];
    
    _switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-50, 107, 45, 45)];
    [_switchBtn setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
    [_switchBtn addTarget:self action:@selector(switchOpenGLView) forControlEvents:UIControlEventTouchUpInside];
    [_remoteView addSubview:_switchBtn];
}

- (void)switchOpenGLView {
    
    NSLog(@"控件高度：%f",_remoteView.frame.size.height);
    
    CGRect rect;
    if (_remoteView.frame.size.height<200) {
        rect = CGRectMake(-(HEIGHT-WIDTH)/2, (HEIGHT-WIDTH)/2, HEIGHT, WIDTH);
        _remoteView.frame = rect;
        
        _tipLab.frame = CGRectMake(0, 0, HEIGHT, WIDTH);
        _switchBtn.frame = CGRectMake(HEIGHT-55, WIDTH-55, 45, 45);
        
        _remoteView.transform = CGAffineTransformMakeRotation(M_PI/2);
    } else {
        
        _remoteView.transform = CGAffineTransformMakeRotation(M_PI*2);
        rect = CGRectMake(0, 104, WIDTH, 160);
        _remoteView.frame = rect;
        
        _tipLab.frame = CGRectMake(0, 0, WIDTH, 160);
        _switchBtn.frame = CGRectMake(WIDTH-50, 107, 45, 45);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES]; //屏幕常亮
    
    _remoteView.hidden = NO;
    [self startMoni];
    
    NSString *readStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"MessageRead"];
    if (![Utils isBlankString:readStr]) {
        self.bellCountLab.hidden = YES;
    } else {
        self.bellCountLab.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO]; //屏幕不常亮
    
    _remoteView.hidden = YES;
    [self stopMoni];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"农场";
    
    [self setNavBar];
    
    self.clearNoteBtn.layer.borderColor = AppThemeColor.CGColor;
    self.clearNoteBtn.layer.borderWidth = 1;
    self.clearNoteBtn.layer.cornerRadius = 5;
    [self.clearNoteBtn.layer setMasksToBounds:YES];
    
    [self createMonitoView];
    
    _isReject=YES;
    _errorStrings=@[
                    @"没有发生错误",
                    @"对方的ID 被禁用",
                    @"对方的ID 过期了",
                    @"对方的ID 尚未激活",
                    @"对方离线",
                    @"对方忙线中",
                    @"对方已关机",
                    @"没有找到协助人",
                    @"对方已经挂断",
                    @"连接超时",
                    @"内部错误",
                    @"无人接听",
                    @"密码错误",
                    @"连接失败",
                    @"连接不支持"
                    ];
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartCamera) name:kEnterForgroundNotification object:nil]; //应用进入前台
}

//重启摄像头
- (void)restartCamera {
    
    _enterStatus = YES;
    _tipLab.hidden = NO;
    _tipLab.text = @"重启中...";
    
    [self startLogin];//开始登录
    [[P2PClient sharedClient] setDelegate:self];
}

- (void)getData {
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_CameraList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            NSArray *array = [CameraInfo mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
            
            NSMutableArray *dataArr = [NSMutableArray array];
            for (int i = 0; i<array.count; i++) {
                CameraInfo *info = array[i];
                
                if ([info.user_id isEqualToString:[UserInfo share].ID]) {
                    [dataArr addObject:info];
                }
            }
            
            if (dataArr.count>0) {
                
                NSString *saveCameraID = [UserInfo share].cameraID;
                
                if ([Utils isBlankString:saveCameraID]) {
                    cameraInfo = dataArr[0];
                } else {
                    
                    for (int i = 0; i<dataArr.count; i++) {
                        CameraInfo *info = dataArr[i];
                        
                        if ([info.ID isEqualToString:saveCameraID]) {
                            cameraInfo = info;
                            break;
                        }
                    }
                }
                
                _petLab.hidden = NO;
                _petLab.text = cameraInfo.name;
                _showRecordBtn.userInteractionEnabled = YES;
                
                [self startLogin];//开始登录
                [[P2PClient sharedClient] setDelegate:self];
            } else {
                _tipLab.text = @"请先添加摄像头";
                _petLab.hidden = YES;
                _showRecordBtn.userInteractionEnabled = NO;
            }
            
        }
    }];
}

- (void)setNavBar {
    
    self.bellCountLab.layer.cornerRadius = self.bellCountLab.width/2;
    [self.bellCountLab.layer setMasksToBounds:YES];
    
    self.signBtn.layer.borderWidth = 1;
    self.signBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.signBtn.layer.cornerRadius = 5;
    [self.signBtn.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加摄像头
- (IBAction)addCameraBtn:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CameraListVC *vc = [story instantiateViewControllerWithIdentifier:@"CameraList"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.backDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//消息中心
- (IBAction)bellAction:(id)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BellListVC *vc = [story instantiateViewControllerWithIdentifier:@"BellList"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//签到
- (IBAction)signAction:(id)sender {
    [[NetworkManager sharedManager] postJSON:URL_SignIn parameters:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            //[Utils showToast:@"签到成功"];
            
            SignView *signView = [[SignView alloc] init];
            [self.view addSubview:signView];
        }
    }];
}

//查看档案
- (IBAction)showRecordAction:(id)sender {
    
    ArchiveInfo *info = [[ArchiveInfo alloc] init];
    info.ID = cameraInfo.archive_id;
    RecordDetailVC *vc = (RecordDetailVC *)[Utils GetStordyVC:@"Main" WithStordyID:@"RecordDetailVC"];
    vc.info = info;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clearNoteAction:(id)sender {
    
    _titleTF.text = nil;
    _contentTF.text = @"输入内容";
}

- (IBAction)saveNoteAction:(id)sender {
    
    if ([Utils isBlankString:_titleTF.text]) {
        [Utils showToast:@"请输入笔记标题"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _titleTF.text, @"title",
                         _contentTF.text,@"content",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_SaveNote parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"保存成功"];
            
            _titleTF.text = nil;
            _contentTF.text = nil;
        }
    }];
}

#pragma mark - BackProtocol 扫码回调代理

- (void)backAction:(CameraInfo *)info {
    
    cameraInfo = info;
    
    NSMutableDictionary *userDic = [[[UserInfo share] getUserInfo] mutableCopy];
    [userDic setObject:cameraInfo.ID forKey:@"cameraID"];
    [[UserInfo share] setUserInfo:userDic];
    
    _petLab.hidden = NO;
    _petLab.text = cameraInfo.name;
    _showRecordBtn.userInteractionEnabled = YES;
    
    _tipLab.hidden = NO;
    _tipLab.text = @"切换中...";
    
    [self startLogin];//开始登录
    [[P2PClient sharedClient] setDelegate:self];
}

#pragma mark - 摄像头

//开始监控
- (void)startMoni {
    
    NSString *status = [[NSUserDefaults standardUserDefaults] objectForKey:@"ForbidWifiWatch"];
    if ([Utils isBlankString:status] && [NetworkUtil currentNetworkStatus]!=NET_WIFI) {
        [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请在wifi环境下观看" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil] show];
        
        return;
    }
    
    if (_isReject&&_hadLogin&&_hadInitDevice) {
        NSLog(@"%@",@"发送呼叫命令");
        [[P2PClient sharedClient] setIsBCalled:NO];
        [[P2PClient sharedClient] setP2pCallState:P2PCALL_STATUS_CALLING];
        
        /**设备密码采用了加密算法加密处理,这样密码有字母也不怕了*/
        [[P2PClient sharedClient] p2pCallWithId:cameraInfo.camera_no
                                       password:[NSString stringWithFormat:@"%ud",[Util GetTreatedPassword:cameraInfo.camera_device_pwd]]
                                       callType:P2PCALL_TYPE_MONITOR];
    }
}

//停止监控
- (void)stopMoni {
    
    if (!_isReject) {
        NSLog(@"%@",@"发送挂断命令");
        _isReject=YES;
        [[P2PClient sharedClient] p2pHungUp];
    }
}

-(void)connectDevice{
    if (_hadLogin) {//只有登录了才去连接设备
        if (!_hadInitDevice) {
            NSLog(@"%@",@"正在初始化设备");
            _hadInitDevice=[[P2PClient sharedClient] p2pConnectWithId:_userIDName codeStr1:_p2pcode1 codeStr2:_p2pcode2];
            NSString* result=[NSString stringWithFormat:@"初始化连接设备 %@",_hadInitDevice?@"成功,你可以操作设备了":@"失败,你将不能操作设备"];
            NSLog(@"%@",result);
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startMoni];//开始监控
        });
        
    }
}

#pragma mark - 协议的实现

- (void)P2PClientCalling:(NSDictionary*)info{
    NSString* str=[NSString stringWithFormat:@"正在呼叫,%@,解释:%@",
                   [self stringFromDic:info],
                   [self stringErrorByError:[info[@"ErrorOption"] integerValue]]];
    NSLog(@"%@",str);
}

- (void)P2PClientReject:(NSDictionary*)info{
    _isReject=YES;
    NSString* str=[NSString stringWithFormat:@"视频挂断,%@,解释:%@",
                   [self stringFromDic:info],
                   [self stringErrorByError:[info[@"ErrorOption"] integerValue]]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_enterStatus == NO) {
            _tipLab.text = [self stringErrorByError:[info[@"ErrorOption"] integerValue]];
        }
        _enterStatus = NO;
    });
    
    NSLog(@"%@",str);
}

- (void)P2PClientAccept:(NSDictionary*)info{
    NSString* str=[NSString stringWithFormat:@"接收数据,%@,解释:%@",
                   [self stringFromDic:info],
                   [self stringErrorByError:[info[@"ErrorOption"] integerValue]]];
    NSLog(@"%@",str);
}

- (void)P2PClientReady:(NSDictionary*)info{
    NSString* str=[NSString stringWithFormat:@"准备就绪,%@,解释:%@",
                   [self stringFromDic:info],
                   [self stringErrorByError:[info[@"ErrorOption"] integerValue]]];
    NSLog(@"%@",str);
    
    //开始渲染
    [[P2PClient sharedClient] setP2pCallState:P2PCALL_STATUS_READY_P2P];
    
    if([[P2PClient sharedClient] p2pCallType]==P2PCALL_TYPE_MONITOR){
        //连接就绪之后就开始启动渲染
        [self monitorStartRender];
    }
}

#pragma mark - 准备渲染监控界面
-(void)monitorStartRender{
    NSLog(@"渲染>>>你可以看到画面了");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _tipLab.hidden = YES;
    });
    
    _isReject = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self renderView];
    });
    [[PAIOUnit sharedUnit] setMuteAudio:NO];
    [[PAIOUnit sharedUnit] setSpeckState:YES];
}

#pragma mark - 开始渲染监控画面
- (void)renderView
{
    GAVFrame * m_pAVFrame;
    while (!_isReject)
    {
        if(fgGetVideoFrameToDisplay(&m_pAVFrame))
        {
            [_remoteView render:m_pAVFrame];
            vReleaseVideoFrame();
        }
        usleep(10000);
    }
}

#pragma mark - 登录相关
/**开始登录*/
-(void)startLogin{
    
    NSString *status = [[NSUserDefaults standardUserDefaults] objectForKey:@"ForbidWifiWatch"];
    if ([Utils isBlankString:status] && [NetworkUtil currentNetworkStatus]!=NET_WIFI) {
        [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请在wifi环境下观看" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil] show];
        
        return;
    }
    
    /**
     登录的方法不是这个demo的重点,此处不详细介绍,欲知详情,请查看登录的demo
     */

    NSLog(@"正在登录");
    
    /**    可供使用的服务器地址:
     api1.cloudlinks.cn
     api2.cloudlinks.cn
     api3.cloud-links.net
     api4.cloud-links.net
     */
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    NSURL* URL = [NSURL URLWithString:@"http://api1.cloudlinks.cn/Users/LoginCheck.ashx"];
    NSDictionary* URLParams = @{
                                @"AppOS": @"2",
                                @"AppVersion":[NSString stringWithFormat:@"%d",2<<24|7<<16|3<<8|4],
                                @"User":cameraInfo.camera_user_name,
                                @"Pwd": [MD5 md5_32bit:cameraInfo.camera_user_pswd],
                                @"Opion": @"GetParam",
                                @"VersionFlag": @" ",
                                };
    URL = NSURLByAppendingQueryParameters(URL, URLParams);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSDictionary* jsonDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                // NSLog(@"返回结果:%@",jsonDic);
                NSString* errCode=jsonDic[@"error_code"];
                if ([errCode isEqualToString:@"0"]) {//返回0即认为是登录成功
                    _hadLogin=YES;
                    NSLog(@"登录成功");
                    //拿到登录成功之后的2个p2p连接码和用户名
                    _userIDName=[NSString stringWithFormat:@"%d",(int)[jsonDic[@"UserID"] integerValue]&0x7fffffff];//用户id就是这样得到的
                    _p2pcode1=jsonDic[@"P2PVerifyCode1"];
                    _p2pcode2=jsonDic[@"P2PVerifyCode2"];
                    [self connectDevice];//开始连接p2p
                    
                }else{
                    _hadLogin=NO;
                    NSLog(@"登录失败,对设备的操作将无效,失败原因:");
                    NSString* theErrStr=jsonDic[@"error"];
                    NSLog(@"%@",theErrStr);
                    _tipLab.text = @"当前摄像头无效";
                }
            }
            else {
                _hadLogin=NO;
                NSString* fal=@"登录失败,对设备的操作将无效,失败原因:";
                fal=[fal stringByAppendingString:[error localizedDescription]];
                NSLog(@"%@",fal);
            }
        });
    }];
    [task resume];//发起任务,开始登录
}

/**
 从字典参数拼接地址
 */
static NSString* NSStringFromQueryParameters(NSDictionary* queryParameters)
{
    NSMutableArray* parts = [NSMutableArray array];
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],
                          [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
                          ];
        [parts addObject:part];
    }];
    return [parts componentsJoinedByString: @"&"];
}

/**
 创建一个带参数的URL地址串
 */
static NSURL* NSURLByAppendingQueryParameters(NSURL* URL, NSDictionary* queryParameters)
{
    NSString* URLString = [NSString stringWithFormat:@"%@?%@",
                           [URL absoluteString],
                           NSStringFromQueryParameters(queryParameters)
                           ];
    NSURL* theUrl=[NSURL URLWithString:URLString];
    return theUrl;
}

-(NSString*)stringFromDic:(NSDictionary*)dic{
    NSString* str=@"";
    if (dic) {
        NSData* data=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return str;
}

-(NSString*)stringErrorByError:(NSInteger)error{
    return _errorStrings[error];
}

@end

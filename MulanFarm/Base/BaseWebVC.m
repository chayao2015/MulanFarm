//
//  BaseWebController.m
//  RentalCar
//
//  Created by zyl on 17/3/23.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseWebVC.h"
#import <WebKit/WebKit.h>
#import "WKDelegateController.h"

@interface BaseWebVC ()<WKUIDelegate,WKNavigationDelegate,WKDelegate,UITextFieldDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) WKUserContentController *userContentController;

@end

@implementation BaseWebVC

/** 传入控制器、url、标题 */
+ (void)showWithContro:(UIViewController *)contro withUrlStr:(NSString *)urlStr withTitle:(NSString *)title isPresent:(BOOL)isPresent {
    BaseWebVC *webVC = [[BaseWebVC alloc] init];
    webVC.homeUrl = urlStr;
    webVC.webTitle = title;
    webVC.isPresent = isPresent;
    if (isPresent==YES) {
        [contro presentViewController:webVC animated:YES completion:nil];
    } else {
        webVC.hidesBottomBarWhenPushed = YES;
        [contro.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _webTitle;
    
    [self configUI];
}

- (void)configUI {
    // 进度条
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 0)];
    _progressView.hidden = YES;
    _progressView.tintColor = AppThemeColor;
    _progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:_progressView];
    
    //配置环境
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    _userContentController =[[WKUserContentController alloc]init];
    configuration.userContentController = _userContentController;
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) configuration:configuration];
    //注册方法
    WKDelegateController *delegateController = [[WKDelegateController alloc]init];
    delegateController.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [self.view insertSubview:_webView belowSubview:_progressView];
    
    //KVO 进度及title、滑动距离
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [_webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[Utils urlEncoding:_homeUrl]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30]];
    
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
}

#pragma mark - 返回事件

// 返回按钮点击
- (void)backAction {
    if (self.isPresent==YES) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - OC调用JS

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}

#pragma mark - JS调用OC

// WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);

}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *url = navigationAction.request.URL.absoluteString;
    
    url = [Utils urlDecoding:url];
    
    NSLog(@"网页链接是否一样：%@\n%@",url,_homeUrl);
    if (url.length>0) {
        if (![url isEqualToString:_homeUrl]) {
            decisionHandler(WKNavigationActionPolicyCancel); //不允许跳转
            
            if ([url containsString:@"http"]) {
                BaseWebVC *webVC = [[BaseWebVC alloc] init];
                webVC.homeUrl = navigationAction.request.URL.absoluteString;
                [self.navigationController pushViewController:webVC animated:YES];
            }
        } else {
            decisionHandler(WKNavigationActionPolicyAllow); //允许跳转
        }
    }
    
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow); //允许跳转
}

#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {

}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}

#pragma mark - WKUIDelegate

// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc] init];
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
        textField.delegate = self;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WKWebView KVO

// 计算WKWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == _webView) {
        
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            
            CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if (newprogress == 1) {
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            } else {
                self.progressView.hidden = NO;
                [self.progressView setProgress:newprogress animated:YES];
            }
        }
        
        if ([keyPath isEqualToString:@"title"]) {
            
        }
    }
}

// 记得取消监听
- (void)dealloc {
    
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

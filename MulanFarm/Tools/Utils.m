//
//  Utils.m
//  ArtEast
//
//  Created by yibao on 16/9/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "Utils.h"
#import <AVFoundation/AVFoundation.h>
#import "TZImageManager.h"
#import <AddressBook/AddressBook.h>
#import "AEToast.h"
#import "NetworkUtil.h"
#import "CommonCrypto/CommonDigest.h"
#import <WebKit/WebKit.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation Utils

//判断网络状态
+ (BOOL)getNetStatus {
    if ([NetworkUtil currentNetworkStatus] != NET_UNKNOWN) { //有网
        return YES;
    } else {
        return NO;
    }
}

//仿安卓消息提示
+ (void)showToast:(NSString *)message {
    [AEToast showBottomWithText:message bottomOffset:100.0 duration:1.5];
}

+ (BOOL)isBlankString:(id)string
{
    string = [NSString stringWithFormat:@"%@",string];
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if([string isEqualToString:@"<null>"])
    {
        return YES;
    }
    if ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (CGFloat)getTextWidth:(NSString *)text fontSize:(float)fontSize forHeight:(CGFloat)height {
    CGSize sizeToFit = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}

+ (CGFloat)getTextHeight:(NSString *) text font:(UIFont *)font forWidth:(CGFloat) width {
    CGSize contentSize;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName: font};
    
    contentSize = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return contentSize.height;
}

+ (NSString *)getPodsResourcePathWithBundleName:(NSString *)bundleName andResourceName:(NSString *)resourceName {
    NSBundle *libBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundleName]];
    if (libBundle && resourceName) {
        NSString *str = [[libBundle resourcePath] stringByAppendingPathComponent:resourceName];
        return str;
    }
    return nil;
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

#pragma mark - 系统权限判断

+ (BOOL)isCameraPermissionOn {
    //相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [self permissionSetup:@"“创艺东方”想访问您的相机"];
            return NO;
        } else {
            return YES;
        }
    } else {
        [AEToast showBottomWithText:@"没有相机功能" bottomOffset:100.0 duration:1.2];
        return NO;
    }
}

+ (BOOL)isPhotoPermissionOn {
    if (![[TZImageManager manager] authorizationStatusAuthorized]) {
        [self permissionSetup:@"“创艺东方”想访问您的相册"];
        return NO;
    } else {
        return YES;
    }
}

+ (void)checkAddressBookAuthorization:(void (^)(bool isAuthorized))block {
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"Error：%@",(__bridge NSError *)error);
                } else if (!granted) {
                    [self permissionSetup:@"“创艺东方”想访问您的通讯录"];
                    block(NO);
                } else {
                    block(YES);
                }
            });
        });
    } else {
        block(YES);
    }
}

+ (void)checkMicrophoneAuthorization:(void (^)(bool isAuthorized))block {
    [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
        if (!granted){
            [self permissionSetup:@"“创艺东方”想访问您的麦克风"];
            block(NO);
        } else {
            block(YES);
        }
    }];
}

//跳转到系统权限设置页面
+ (void)permissionSetup:(NSString *)title {
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转到系统设置
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }]];
    //弹出提示框；
    [[Utils getCurrentVC] presentViewController:alert animated:true completion:nil];
}

+ (NSString *)md5HexDigest:(NSString *)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (unsigned int)strlen(str), result);
    NSMutableString *textMd5 = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [textMd5 appendFormat:@"%02X",result[i]];
    }
    return textMd5;
}

+ (NSString *)getCurrentTime {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSString *h5JsonStr = @"";
    NSArray *arrKey = [dic allKeys];
    if (arrKey.count>0) {
        h5JsonStr = [NSString stringWithFormat:@"{"];
        for (int i = 0; i<arrKey.count; i++) {
            if (i == arrKey.count-1) {
                h5JsonStr = [NSString stringWithFormat:@"%@%@:%@}",h5JsonStr,arrKey[i],dic[arrKey[i]]];
            } else {
                h5JsonStr = [NSString stringWithFormat:@"%@%@:%@,",h5JsonStr,arrKey[i],dic[arrKey[i]]];
            }
        }
    }
    return h5JsonStr;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (BOOL)isUserLogin {
    if ([UserInfo share].ID.length>0) {
        return YES;
    } else {
        return NO;
    }
}

//正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    // 电信号段:133/153/180/181/189/177
    // 联通号段:130/131/132/155/156/185/186/145/176
    // 移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    // 虚拟运营商:170
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

//计算文字所占大小
+ (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:font]} context:nil].size;
    size.width += 5;
    return size;
}

//打电话
+ (UIWebView *)call:(NSString *)phoneAccount {
    NSString *callPhone = phoneAccount;
    UIWebView *callWebView = [[UIWebView alloc] init];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",callPhone]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    return  callWebView;
}

+ (void)clearCache {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *files= [[NSFileManager defaultManager] subpathsAtPath:kCachePath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [kCachePath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //缓存清除完毕
        });
    });
}

+ (void)addDeleteLine:(UILabel *)view andContent:(NSString *)content andRang:(NSRange )range {
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:content];
    [attriString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    [view setAttributedText:attriString];
}

+ (NSString *)urlEncoding:(NSString *)urlString {
    return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)urlDecoding:(NSString *)str {
    return [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)stringByEncodingURLFormat:(NSString*)_key {
    NSString *encodedString = ( NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)_key, nil, (CFStringRef) @"!$&'()*+,-./:;=?@_~%#[]", kCFStringEncodingUTF8));
    //由于ARC的存在，这里的转换需要添加__bridge，原因我不明。求大神讲解
    return encodedString;
}

#pragma mark - 截取网页附带的参数转换成字典
+ (NSMutableDictionary *)subWebUrlParChangeDic:(NSString *)urlStr {
    //获取问号的位置，问号后是参数列表
    NSRange range = [urlStr rangeOfString:@"?"];
    NSLog(@"参数列表开始的位置：%d", (int)range.location);
    
    //获取参数列表
    NSString *propertys = [urlStr substringFromIndex:(int)(range.location+1)];
    NSLog(@"截取的参数列表：%@", propertys);
    
    //进行字符串的拆分，通过&来拆分，把每个参数分开
    NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
    NSLog(@"把每个参数列表进行拆分，返回为数组：\n%@", subArray);
    
    //把subArray转换为字典
    //tempDic中存放一个URL中转换的键值对
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:4];
    
    for (int j = 0 ; j < subArray.count; j++)
    {
        //在通过=拆分键和值
        NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
        NSLog(@"再把每个参数通过=号进行拆分：\n%@", dicArray);
        //给字典加入元素
        [tempDic setObject:dicArray[1] forKey:dicArray[0]];
    }
    NSLog(@"打印参数列表生成的字典：\n%@", tempDic);
    
    return tempDic;
}

#pragma mark - 屏幕快照
+ (UIImage *)snapshotSingleView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//根据时间戳获取星期几
+ (NSString *)getWeekDayFordate:(long long)data
{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}

//根据NSString类型时间戳转换为日期格式
+ (NSString *)getDateAccordingTime:(NSString *)aTime formatStyle:(NSString *)formate{
    
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:[aTime intValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:formate];
    return[formatter stringFromDate:nowDate];
}

@end
